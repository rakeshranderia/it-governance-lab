#!/usr/bin/env bash

# Module 3 expected architecture:
# HTTP :80  -> redirect
# HTTPS :443 -> application HTTP 200
# Self-signed TLS is intentional, so curl uses -k for the HTTPS check.

set -u

PASS=0
FAIL=0

pass() { printf '[PASS] %s\n' "$1"; PASS=$((PASS + 1)); }
fail() { printf '[FAIL] %s\n' "$1"; FAIL=$((FAIL + 1)); }

echo "LAMP Asset Register health check - Module 3"
echo "==========================================="

if systemctl is-active --quiet apache2; then
  pass "Apache service is active"
else
  fail "Apache service is not active"
fi

if systemctl is-active --quiet mariadb; then
  pass "MariaDB service is active"
else
  fail "MariaDB service is not active"
fi

if ss -ltn | grep -Eq '[:.]80[[:space:]]'; then
  pass "TCP port 80 is listening"
else
  fail "TCP port 80 is not listening"
fi

if ss -ltn | grep -Eq '[:.]443[[:space:]]'; then
  pass "TCP port 443 is listening"
else
  fail "TCP port 443 is not listening"
fi

if php -r 'exit(extension_loaded("pdo_mysql") ? 0 : 1);' 2>/dev/null; then
  pass "PHP PDO MySQL driver is loaded"
else
  fail "PHP PDO MySQL driver is not loaded"
fi

HTTP_CODE="$(curl -sS -o /dev/null -w '%{http_code}' http://localhost/assets.php 2>/dev/null || true)"
case "$HTTP_CODE" in
  301|302|307|308) pass "HTTP endpoint redirects (${HTTP_CODE})" ;;
  *) fail "HTTP endpoint did not redirect (status ${HTTP_CODE:-unavailable})" ;;
esac

HTTPS_CODE="$(curl -k -sS -o /dev/null -w '%{http_code}' https://localhost/assets.php 2>/dev/null || true)"
if [ "$HTTPS_CODE" = "200" ]; then
  pass "HTTPS asset application returns HTTP 200"
else
  fail "HTTPS asset application status is ${HTTPS_CODE:-unavailable}"
fi

DB_COUNT="$(sudo -n mariadb -N -e 'SELECT COUNT(*) FROM assetlab.assets;' 2>/dev/null || true)"
if [[ "$DB_COUNT" =~ ^[0-9]+$ ]]; then
  pass "Database query succeeded (${DB_COUNT} asset rows)"
else
  fail "Database query failed or passwordless sudo is unavailable"
fi

echo
echo "Summary: ${PASS} passed, ${FAIL} failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
