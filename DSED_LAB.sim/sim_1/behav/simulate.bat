@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim FSMD_microphone_tb2_behav -key {Behavioral:sim_1:Functional:FSMD_microphone_tb2} -tclbatch FSMD_microphone_tb2.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
