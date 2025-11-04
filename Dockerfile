FROM quay.io/keycloak/keycloak:23.0.7 AS builder

ARG KC_HEALTH_ENABLED KC_METRICS_ENABLED KC_FEATURES KC_DB KC_HTTP_ENABLED PROXY_ADDRESS_FORWARDING QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY KC_HOSTNAME KC_LOG_LEVEL KC_DB_POOL_MIN_SIZE

COPY theme/iasystock /opt/keycloak/themes/iasystock
COPY realm-config /opt/keycloak/data/import
COPY keycloak.conf /opt/keycloak/conf/keycloak.conf

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:23.0.7

COPY java.config /etc/crypto-policies/back-ends/java.config
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

CMD ["start", "--optimized", "--import-realm", "--import-realm-strategy=OVERWRITE_EXISTING"]
