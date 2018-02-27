-- View I/O Statistics For All Tables
-- Author: Unknown (possibly me?)

-- View: maint_statio_all_tables

-- DROP VIEW maint_statio_all_tables;

CREATE OR REPLACE VIEW maint_statio_all_tables AS 
 SELECT pg_statio_all_tables.relid,
    pg_statio_all_tables.schemaname,
    pg_statio_all_tables.relname,
    pg_statio_all_tables.heap_blks_read,
    pg_statio_all_tables.heap_blks_hit,
    pg_statio_all_tables.idx_blks_read,
    pg_statio_all_tables.idx_blks_hit,
    pg_statio_all_tables.toast_blks_read,
    pg_statio_all_tables.toast_blks_hit,
    pg_statio_all_tables.tidx_blks_read,
    pg_statio_all_tables.tidx_blks_hit
   FROM pg_statio_all_tables
  WHERE pg_statio_all_tables.schemaname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name, 'pg_toast'::name])
  ORDER BY pg_statio_all_tables.relname;
