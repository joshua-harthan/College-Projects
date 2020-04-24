-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\lab3_p9\dataplane_ip_src_LED_persistence_control.vhd
-- Created: 2020-04-17 18:41:15
-- 
-- Generated by MATLAB 9.8 and HDL Coder 3.16
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: dataplane_ip_src_LED_persistence_control
-- Source Path: lab3_p9/dataplane/Avalon Data Processing/Left Channel Processing/Signal Energy Monitor/LED_Driver/LED_persistence_control
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dataplane_ip_src_LED_persistence_control IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        LED_trigger                       :   IN    std_logic;
        LED_persistence                   :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
        Enable_out5                       :   IN    std_logic;
        LED_control                       :   OUT   std_logic
        );
END dataplane_ip_src_LED_persistence_control;


ARCHITECTURE rtl OF dataplane_ip_src_LED_persistence_control IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT dataplane_ip_src_Chart
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          LED_trigger                     :   IN    std_logic;
          count_reached                   :   IN    std_logic;
          LED_signal                      :   OUT   std_logic;
          counter_reset                   :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : dataplane_ip_src_Chart
    USE ENTITY work.dataplane_ip_src_Chart(rtl);

  -- Signals
  SIGNAL enb_gated                        : std_logic;
  SIGNAL LED_persistence_unsigned         : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL enb_gated_1                      : std_logic;
  SIGNAL counter_reset                    : std_logic;
  SIGNAL counter_reset_last_value         : std_logic;
  SIGNAL counter_reset_1                  : std_logic;
  SIGNAL Logical_Operator_out1            : std_logic;
  SIGNAL HDL_Counter_out1                 : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL Relational_Operator_relop1       : std_logic;
  SIGNAL LED_signal                       : std_logic;
  SIGNAL LED_signal_1                     : std_logic;
  SIGNAL LED_signal_last_value            : std_logic;

BEGIN
  u_Chart : dataplane_ip_src_Chart
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb_gated,
              LED_trigger => LED_trigger,
              count_reached => Relational_Operator_relop1,
              LED_signal => LED_signal,
              counter_reset => counter_reset_1
              );

  enb_gated <= Enable_out5 AND enb;

  LED_persistence_unsigned <= unsigned(LED_persistence);

  enb_gated_1 <= Enable_out5 AND enb;

  out1_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      counter_reset_last_value <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_gated = '1' THEN
        counter_reset_last_value <= counter_reset;
      END IF;
    END IF;
  END PROCESS out1_bypass_process;


  
  counter_reset <= counter_reset_last_value WHEN Enable_out5 = '0' ELSE
      counter_reset_1;

  Logical_Operator_out1 <= counter_reset OR LED_trigger;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  HDL_Counter_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      HDL_Counter_out1 <= to_unsigned(16#0000#, 15);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_gated_1 = '1' THEN
        IF Logical_Operator_out1 = '1' THEN 
          HDL_Counter_out1 <= to_unsigned(16#0000#, 15);
        ELSE 
          HDL_Counter_out1 <= HDL_Counter_out1 + to_unsigned(16#0001#, 15);
        END IF;
      END IF;
    END IF;
  END PROCESS HDL_Counter_process;


  
  Relational_Operator_relop1 <= '1' WHEN LED_persistence_unsigned <= HDL_Counter_out1 ELSE
      '0';

  out0_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      LED_signal_last_value <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_gated = '1' THEN
        LED_signal_last_value <= LED_signal_1;
      END IF;
    END IF;
  END PROCESS out0_bypass_process;


  
  LED_signal_1 <= LED_signal_last_value WHEN Enable_out5 = '0' ELSE
      LED_signal;

  LED_control <= LED_signal_1;

END rtl;
