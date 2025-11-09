@ECHO OFF
REM
REM	===========================================================================
REM	 Created on:   	11/09/2025 
REM	 Created by:   	Doctor Mister Danger
REM	 Filename:     	sysprep.cmd
REM  Description:   A collection of commands used to configure the OS to taste.
REM	===========================================================================
REM
@ECHO ON
TITLE System Prep
:InvokeAdminPriviledges
IF not "%1"=="am_admin" (pwsh start -verb runas '%0' am_admin & exit /b)
:InstallWinget
pwsh Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile winget.msixbundle
pwsh Add-AppxPackage winget.msixbundle
