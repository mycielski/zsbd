-- Create users
CREATE USER financial WITH PASSWORD 'financial';
CREATE USER compliance WITH PASSWORD 'compliance';

-- Create schemas
CREATE SCHEMA IF NOT EXISTS financial_views;
CREATE SCHEMA IF NOT EXISTS compliance_views;

-- Grant schema usage
GRANT USAGE ON SCHEMA financial_views TO financial;
GRANT USAGE ON SCHEMA compliance_views TO compliance;

-- Grant usage on public schema (needed to access source tables)
GRANT USAGE ON SCHEMA public TO financial;
GRANT USAGE ON SCHEMA public TO compliance;

-- Grant SELECT on source tables for view creation
GRANT SELECT ON public.driver_hours TO financial;
GRANT SELECT ON public.fuel_cost_per_driver_hour TO financial;
GRANT SELECT ON public.money_spent TO financial;

GRANT SELECT ON public.measured_refuelings TO compliance;
GRANT SELECT ON public.reported_refuelings TO compliance;
GRANT SELECT ON public.suspected_fraudsters TO compliance;

-- Create views in appropriate schemas
CREATE OR REPLACE VIEW financial_views.driver_hours AS 
SELECT * FROM public.driver_hours;

CREATE OR REPLACE VIEW financial_views.fuel_cost_per_driver_hour AS 
SELECT * FROM public.fuel_cost_per_driver_hour;

CREATE OR REPLACE VIEW financial_views.money_spent AS 
SELECT * FROM public.money_spent;

CREATE OR REPLACE VIEW compliance_views.measured_refuelings AS 
SELECT * FROM public.measured_refuelings;

CREATE OR REPLACE VIEW compliance_views.reported_refuelings AS 
SELECT * FROM public.reported_refuelings;

CREATE OR REPLACE VIEW compliance_views.suspected_fraudsters AS 
SELECT * FROM public.suspected_fraudsters;

-- Grant SELECT on views
GRANT SELECT ON financial_views.driver_hours TO financial;
GRANT SELECT ON financial_views.fuel_cost_per_driver_hour TO financial;
GRANT SELECT ON financial_views.money_spent TO financial;

GRANT SELECT ON compliance_views.measured_refuelings TO compliance;
GRANT SELECT ON compliance_views.reported_refuelings TO compliance;
GRANT SELECT ON compliance_views.suspected_fraudsters TO compliance;

-- Revoke unnecessary public schema access
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM financial;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM compliance;
