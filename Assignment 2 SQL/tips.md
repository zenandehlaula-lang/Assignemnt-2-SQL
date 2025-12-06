
**Project Tips & Standards**

Purpose: A concise set of practical tips to help you develop, document and validate SQL work in this repository.

**Quick Project Layout**
- **`data/`**: raw data files (e.g., `dirty_hotel_bookings.csv`).
- **`sql/`**: numbered SQL scripts that form the pipeline (`01_create_raw_table.sql` → `08_export_for_powerbi.sql`).
- **`docs/`**: process notes, issue register and validation reports.

**Quick Start**
- Recommended engine: Postgres (examples below use `psql`). You can adapt commands for your database.
- To run one SQL file against a database:

```
# Postgres: run a single SQL script
psql -h <HOST> -U <USER> -d <DBNAME> -f sql/01_create_raw_table.sql

# SQLite (for small local tests):
sqlite3 my.db < sql/01_create_raw_table.sql
```

**Development Workflow (high level)**
- 1) Ingest raw data: create raw tables from CSVs or external sources (`01_create_raw_table.sql`).
- 2) Detect issues: run `02_issue_detection.sql` to identify data quality problems and log them to `docs/issue_register.md`.
- 3) Build reference tables: add lookup/reference tables needed for joins and enrichment (`03_reference_tables.sql`).
- 4) Build staging: transform raw into a neutral, cleaned staging schema (`04_build_staging_table.sql`).
- 5) Clean/standardise: apply business rules in `05_build_clean_table.sql` producing the canonical clean table.
- 6) Validation: implement automated checks in `06_validation_checks.sql` and record results in `docs/validation_report.md`.
- 7) Analysis/views: create analytic views in `07_create_analysis_views.sql`.
- 8) Export: prepare outputs for downstream tools (`08_export_for_powerbi.sql`).

**Validation & Testing**
- Always include automated checks for: row counts, null rates, unique constraints, foreign-key coverage, and sample value ranges.
- Example checks to include in `06_validation_checks.sql`:
	- Row count matches expectation between stages.
	- No unexpected NULLs in required columns (e.g., `booking_id`, `arrival_date`).
	- All reference keys map to reference tables (report unmapped rows, do not silently drop them).
	- Business-rule spot checks (e.g., lead time >= 0, price >= 0).

**SQL Style & Best Practices**
- Use clear, consistent naming: `schema.table_name`, `snake_case` for columns.
- Prefer named CTEs over nested subqueries for readability.
- Avoid `SELECT *`; list only required columns and alias expressions clearly.
- Handle NULLs explicitly using `COALESCE`, `NULLIF`, or `CASE` as appropriate.
- Use window functions for ranking/lag/lead rather than self-joins when appropriate.
- Include brief comment blocks at the top of each SQL file describing intent and expected outputs.

**Documentation & Assessment Alignment**
- Keep `docs/issue_register.md` up to date; log each issue with: id, description, detection query, proposed fix, owner, status.
- Validation: provide at least 5 automated checks as part of the assessment (record results in `docs/validation_report.md`).
- Reference tables: ensure you have at least 2 meaningful reference tables (e.g., country codes, room type mappings).

**Common Pitfalls & How to Avoid Them**
- INNER JOIN with reference tables: use LEFT JOIN and report unmapped reference keys so you don't drop data unexpectedly.
- Ignoring NULLs: be explicit — NULLs often mean unknown/missing, not zero or empty string.
- Applying fixes without validating on a sample: always test rules on a small subset first and review results.

**Checklist Before Submission / Handover**
- **Issues**: recorded in `docs/issue_register.md` with at least 5 distinct issues documented.
- **Validation**: at least 5 automated checks present and passing or documented failures explained.
- **Docs**: `process_report.md` and `validation_report.md` updated with business context and remediation rationale.
- **SQL**: files in `sql/` are ordered, annotated, and idempotent where possible.
