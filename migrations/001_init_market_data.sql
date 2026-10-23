-- 001_init_market_data.sql
-- Database schema for Market Data Service

CREATE TABLE IF NOT EXISTS sync_state (
    exchange VARCHAR(32) NOT NULL,
    symbol VARCHAR(32) NOT NULL,
    timeframe VARCHAR(16) NOT NULL,
    first_ts BIGINT,
    last_ts BIGINT,
    status VARCHAR(32) NOT NULL DEFAULT 'IDLE',
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (exchange, symbol, timeframe)
);

CREATE INDEX IF NOT EXISTS idx_sync_state_exchange_symbol ON sync_state(exchange, symbol);

CREATE TABLE IF NOT EXISTS sync_runs (
    id UUID PRIMARY KEY,
    exchange VARCHAR(32) NOT NULL,
    symbol VARCHAR(32) NOT NULL,
    timeframe VARCHAR(16) NOT NULL,
    requested_start BIGINT,
    requested_end BIGINT,
    status VARCHAR(32) NOT NULL DEFAULT 'QUEUED',
    candles_added INTEGER NOT NULL DEFAULT 0,
    gaps_found INTEGER NOT NULL DEFAULT 0,
    error TEXT,
    started_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_sync_runs_symbol_tf ON sync_runs(exchange, symbol, timeframe);
CREATE INDEX IF NOT EXISTS idx_sync_runs_status ON sync_runs(status);
CREATE INDEX IF NOT EXISTS idx_sync_runs_started ON sync_runs(started_at DESC);
