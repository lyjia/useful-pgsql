-- View size and usage statistics for indices
-- Author: Unknown

-- View: maint_index_size_usage

-- DROP VIEW maint_index_size_usage;

CREATE OR REPLACE VIEW maint_index_size_usage AS 
 SELECT t.tablename,
    foo.indexname,
    c.reltuples AS num_rows,
    pg_size_pretty(pg_relation_size(quote_ident(t.tablename::text)::regclass)) AS table_size,
    pg_size_pretty(pg_relation_size(quote_ident(foo.indexrelname::text)::regclass)) AS index_size,
        CASE
            WHEN x.is_unique = 1 THEN 'Y'::text
            ELSE 'N'::text
        END AS "unique",
    foo.idx_scan AS number_of_scans,
    foo.idx_tup_read AS tuples_read,
    foo.idx_tup_fetch AS tuples_fetched
   FROM pg_tables t
     LEFT JOIN pg_class c ON t.tablename = c.relname
     LEFT JOIN ( SELECT pg_index.indrelid,
            max(pg_index.indisunique::integer) AS is_unique
           FROM pg_index
          GROUP BY pg_index.indrelid) x ON c.oid = x.indrelid
     LEFT JOIN ( SELECT c_1.relname AS ctablename,
            ipg.relname AS indexname,
            x_1.indnatts AS number_of_columns,
            psai.idx_scan,
            psai.idx_tup_read,
            psai.idx_tup_fetch,
            psai.indexrelname
           FROM pg_index x_1
             JOIN pg_class c_1 ON c_1.oid = x_1.indrelid
             JOIN pg_class ipg ON ipg.oid = x_1.indexrelid
             JOIN pg_stat_all_indexes psai ON x_1.indexrelid = psai.indexrelid) foo ON t.tablename = foo.ctablename
  WHERE t.schemaname = 'public'::name
  ORDER BY t.tablename, foo.indexname;
