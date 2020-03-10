@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto a9b082810ecd4554a74c2f800bd0f577 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot FSMD_microphone_tb2_behav xil_defaultlib.FSMD_microphone_tb2 -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
