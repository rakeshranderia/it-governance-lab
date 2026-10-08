#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

pass() { printf '[PASS] %s\n' "$1"; PASS=$((PASS + 1)); }
fail() { printf '[FAIL] %s\n' "$1"; FAIL=$((FAIL + 1)); }

echo "LAMP Asset Register health check - Module 3"
echo "==========================================="

systemctl is-active --quiet apache2 && pass "Apache service is active" || fail "Apache service is not active"
systemctl is-active --quiet mariadb && pass "MariaDB service is active" || fail "MariaDB service is not active"

ss -ltn | grep -Eq '[:.]80[[:space:]]' && pass "TCP port 80 is listening" || fail "TCP port 80 is not listening"
ss -ltn | grep -Eq '[:.]443[[:space:]]' && pass "TCP port 443 is listening" || fail "TCP port 443 is not listening"

php -r 'exit(extension_loaded("pdo_mysql") ? 0 : 1);' 2>/dev/null \
  && pass "PHP PDO MySQL driver is loaded" \
  || fail "PHP PDO MySQL driver is not loaded"

HTTP_CODE="$(curl -sS -o /dev/null -w '%{http_code}' http://localhost/assets.php 2>/dev/null || true)"
case "$HTTP_CODE" in
  301|302|307|308) pass "HTTP endpoint redirects (${HTTP_CODE})" ;;
  *) fail "HTTP endpoint did not redirect (status ${HTTP_CODE:-unavailable})" ;;
esac

HTTPS_CODE="$(curl -k -sS -o /dev/null -w '%{http_code}' https://localhost/assets.php 2>/dev/null || true)"
[ "$HTTPS_CODE" = "200" ] \
  && pass "HTTPS asset application returns HTTP 200" \
  || fail "HTTPS asset application status is ${HTTPS_CODE:-unavailable}"

DB_COUNT="$(sudo -n mariadb -N -e 'SELECT COUNT(*) FROM assetlab.assets;' 2>/dev/null || true)"
if [[ "$DB_COUNT" =~ ^[0-9]+$ ]]; then
  pass "Database query succeeded (${DB_COUNT} asset rows)"
else
  fail "Database query failed or passwordless sudo is unavailable"
fi

echo
echo "Summary: ${PASS} passed, ${FAIL} failed"

[ "$FAIL" -eq 0 ]
