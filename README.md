# ISpyGameDatabase

Data Dogs is a MySQL database project created for my database class. Our group used game data from IGDB and organized it into a relational database containing games, developers, platforms, languages, categories, users, and wishlists.

## What the Project Does

The database stores game information and connects games to their developers, platforms, languages, and categories.

It also includes a wishlist system where users can save games.

Some of the SQL features used in the project include:

- joins and subqueries
- aggregate queries
- many-to-many relationships
- recursive CTEs
- triggers
- stored procedures
- stored functions
- audit logs

## Database Structure

Main tables:

- `Game`
- `Developer`
- `Platform`
- `Language`
- `Category`
- `User`
- `Wishlist`

Junction tables:

- `GamePlatform`
- `GameLanguage`
- `GameCategory`

The project also includes logging tables for rating changes and deleted wishlist entries.

## SQL Automation

The database contains several automated features:

- A trigger that automatically adds the current date to new wishlist entries
- A trigger that logs game rating changes
- A trigger that records deleted wishlist entries
- An `AddToWishlist` stored procedure
- A `GetUserWishlistCount` function

## Example Queries

The project includes queries for things such as:

- most wishlisted games
- average ratings by developer
- games available on each platform
- supported languages
- games with above-average ratings
- wishlist totals by user

## Files

- `data_dogs_dump.sql` - complete database dump
- `schema_and_population.sql` - database schema and data population
- `queries.sql` - project queries
- `triggers_functions_automation.sql` - triggers, procedure, and function
- `datadogs_Schema.mwb` - MySQL Workbench model

## Setup

To restore the full database:

```bash
mysql -u root -p < data_dogs_dump.sql
