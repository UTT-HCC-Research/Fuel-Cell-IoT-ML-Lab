function PlotPEMFC(t_fc,Ifc,Vfc)
excelFile = "Data\Example_PEMFC_data_2026.xlsx";

Tdata = readtable(excelFile, ...
    "FileType", "spreadsheet", ...
    "VariableNamingRule", "preserve");

Tdata.Properties.VariableNames = ...
    cellstr(strtrim(string(Tdata.Properties.VariableNames)));

disp("Detected Excel columns:");
disp(Tdata.Properties.VariableNames');