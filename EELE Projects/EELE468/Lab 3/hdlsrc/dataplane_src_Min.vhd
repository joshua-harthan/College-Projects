-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\lab3_p9\dataplane_src_Min.vhd
-- Created: 2020-04-17 18:44:58
-- 
-- Generated by MATLAB 9.8 and HDL Coder 3.16
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: dataplane_src_Min
-- Source Path: lab3_p9/dataplane/Avalon Data Processing/Left Channel Processing/Signal Energy Monitor/Normalize 
-- Signal/Min/Mi
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.dataplane_src_dataplane_pkg.ALL;

ENTITY dataplane_src_Min IS
  PORT( in0                               :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        in1                               :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        out0                              :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END dataplane_src_Min;


ARCHITECTURE rtl OF dataplane_src_Min IS

  -- Signals
  SIGNAL Min_muxout                       : vector_of_signed32(0 TO 1);  -- sfix32_En28 [2]
  SIGNAL Min_stage1_val                   : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  Min_muxout(0) <= signed(in0);
  Min_muxout(1) <= signed(in1);

  ---- Tree min implementation ----
  ---- Tree min stage 1 ----
  
  Min_stage1_val <= Min_muxout(0) WHEN Min_muxout(0) <= Min_muxout(1) ELSE
      Min_muxout(1);

  out0 <= std_logic_vector(Min_stage1_val);

END rtl;
