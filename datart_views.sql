-- Datart SQL View definitions for the charging pile BI dashboard.
-- Create these views in Datart with the MySQL source pointing to database `enger`.

-- v1_voltage_current
SELECT * FROM enger.t_enger1;

-- v2_cell_voltage
SELECT * FROM enger.t_enger2;

-- v3_temperature
SELECT * FROM enger.t_enger3;

-- v4_energy_capacity
SELECT * FROM enger.t_enger4;

-- v5_charge_current
SELECT * FROM enger.t_enger5;

-- v6_voltage_current_change
SELECT * FROM enger.t_enger6;

-- v7_battery_status
SELECT * FROM enger.t_enger7;

