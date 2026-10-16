# 💰 Personal Finance Tracker

A MySQL project focused on personal finance management.  
Built to strengthen SQL skills through real-world schema design, 
queries, stored procedures, and data analysis.

## 🎯 Goals
- Design a normalized database schema
- Practice complex SQL queries (JOINs, CTEs, Window Functions)
- Write reusable stored procedures
- Optimize queries with indexes and views

## 🛠️ Tech Stack
- MySQL

## 📂 Structure

### schema/
| File | Description |
|------|-------------|
| `01_create_tables.sql` | Table definitions with constraints and foreign keys |
| `02_indexes.sql` | Indexes for query performance optimization |
| `03_views.sql` | Reusable views for common queries |

### data/
| File | Description |
|------|-------------|
| `sample_data.sql` | Sample data for testing |

### queries/
| File | Description |
|------|-------------|
| `01_joins_and_aggregations.sql` | JOINs, GROUP BY, HAVING |
| `02_common_table_expressions.sql` | CTEs and chained CTEs |
| `03_window_functions.sql` | SUM OVER, ROW_NUMBER, LAG, LEAD |

### procedures/
| File | Description |
|------|-------------|
| `01_get_customer_transactions.sql` | Get all transactions for a customer |
| `02_get_customer_balance.sql` | Get income, expenses and balance |
| `03_monthly_spent.sql` | Get total expenses per month |
| `04_transfer_fund.sql` | Transfer funds between accounts |

### docs/
| File | Description |
|------|-------------|
| `er_diagram.md` | Entity Relationship Diagram |

## 📚 Concepts Covered
- Schema design & normalization
- JOINs (INNER, multiple tables)
- Aggregations (SUM, GROUP BY, HAVING)
- CTEs & chained CTEs
- Window Functions (SUM OVER, ROW_NUMBER, LAG, LEAD)
- Stored Procedures with IN parameters
- Views for reusable queries
- Query optimization with EXPLAIN & indexes
- Data integrity with FOREIGN KEYs & ENUM
