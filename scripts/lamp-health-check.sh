#!/usr/bin/env bash

# LAMP Asset Register - simple health check
# Designed for Ubuntu 22.04 lab VM.
# Returns exit code 0 when all core checks pass, 1 when one or more fail.

set -u

PASS=0
FAIL=0

pass() {
  printf '[PASS] %s\n' "$1"
  PASS=$((PASS + 1))
}

fail() {
  printf '[FAIL] %s\n' "$1"
  FAIL=$((FAIL + 1))
}

info() {
  printf '[INFO] %s\n' "$1"
}

echo "LAMP Asset Register health check"
echo "================================"

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

if php -r 'exit(extension_loaded("pdo_mysql") ? 0 : 1);' 2>/dev/null; then
  pass "PHP PDO MySQL driver is loaded"
else
  fail "PHP PDO MySQL driver is not loaded"
fi

HTTP_CODE="$(curl -sS -o /dev/null -w '%{http_code}' http://localhost/assets.php 2>/dev/null || true)"

if [ "$HTTP_CODE" = "200" ]; then
  pass "Asset application returns HTTP 200 locally"
else
  fail "Asset application local HTTP status is ${HTTP_CODE:-unavailable}"
fi

DB_COUNT="$(sudo -n mariadb -N -e 'SELECT COUNT(*) FROM assetlab.assets;' 2>/dev/null || true)"

if [[ "$DB_COUNT" =~ ^[0-9]+$ ]]; then
  pass "Database query succeeded (${DB_COUNT} asset rows)"
else
  fail "Database query failed or passwordless sudo is unavailable"
fi

if ss -ltn | grep -Eq '[:.]443[[:space:]]'; then
  info "TCP port 443 is listening"
else
  info "TCP port 443 is not listening yet (expected before Module 3 HTTPS)"
fi

echo
echo "Summary: ${PASS} passed, ${FAIL} failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi

exit 0
