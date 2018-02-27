-- View: maint_index_summary

-- DROP VIEW maint_index_summary;

CREATE OR REPLACE VIEW maint_index_summary AS 
 SELECT pg_class.relname,
    pg_size_pretty(pg_class.reltuples::bigint) AS rows_in_bytes,
    pg_class.reltuples AS num_rows,
    count(foo.indexname) AS number_of_indexes,
        CASE
            WHEN x.is_unique = 1 THEN 'Y'::text
            ELSE 'N'::text
        END AS "unique",
    sum(
        CASE
            WHEN foo.number_of_columns = 1 THEN 1
            ELSE 0
        END) AS single_column,
    sum(
        CASE
            WHEN foo.number_of_columns IS NULL THEN 0
            WHEN foo.number_of_columns = 1 THEN 0
            ELSE 1
        END) AS multi_column
   FROM pg_namespace
     LEFT JOIN pg_class ON pg_namespace.oid = pg_class.relnamespace
     LEFT JOIN ( SELECT pg_index.indrelid,
            max(pg_index.indisunique::integer) AS is_unique
           FROM pg_index
          GROUP BY pg_index.indrelid) x ON pg_class.oid = x.indrelid
     LEFT JOIN ( SELECT c.relname AS ctablename,
            ipg.relname AS indexname,
            x_1.indnatts AS number_of_columns
           FROM pg_index x_1
             JOIN pg_class c ON c.oid = x_1.indrelid
             JOIN pg_class ipg ON ipg.oid = x_1.indexrelid) foo ON pg_class.relname = foo.ctablename
  WHERE pg_namespace.nspname = 'public'::name AND pg_class.relkind = 'r'::"char"
  GROUP BY pg_class.relname, pg_class.reltuples, x.is_unique
  ORDER BY pg_size_pretty(pg_class.reltuples::bigint);
