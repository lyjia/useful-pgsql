-- View: maint_index_find_dupes

-- DROP VIEW maint_index_find_dupes;

CREATE OR REPLACE VIEW maint_index_find_dupes AS 
 SELECT pg_size_pretty(sum(pg_relation_size(sub.idx))::bigint) AS size,
    (array_agg(sub.idx))[1] AS idx1,
    (array_agg(sub.idx))[2] AS idx2,
    (array_agg(sub.idx))[3] AS idx3,
    (array_agg(sub.idx))[4] AS idx4
   FROM ( SELECT pg_index.indexrelid::regclass AS idx,
            (((((((pg_index.indrelid::text || '
'::text) || pg_index.indclass::text) || '
'::text) || pg_index.indkey::text) || '
'::text) || COALESCE(pg_index.indexprs::text, ''::text)) || '
'::text) || COALESCE(pg_index.indpred::text, ''::text) AS key
           FROM pg_index) sub
  GROUP BY sub.key
 HAVING count(*) > 1
  ORDER BY sum(pg_relation_size(sub.idx)) DESC;
