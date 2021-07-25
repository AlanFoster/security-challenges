--------------------------------------------------------------------
-- Schema
--------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS flags (
  id             SERIAL PRIMARY KEY,
  value          VARCHAR(255) NOT NULL,

  created_at     TIMESTAMP WITHOUT TIME ZONE,
  deleted_at     TIMESTAMP WITHOUT TIME ZONE
);
