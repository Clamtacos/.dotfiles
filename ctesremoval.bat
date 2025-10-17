@echo on
title Annoying Services Removal Script
sc stop "Ctes Manager"
sc stop "rpchdp"
sc stop "CtesHostSvc"
sc stop "rpcnet"
sc stop "rpcnetp"