function [Price,Names]= intrument(BKTree,Startdate)
Settle = Startdate;
filename ='Portfolio.xlsx';
T = readtable(filename);
headings = T.Properties.VariableNames(1:end)';
CouponRate = xlsread(filename,'A:A');
Holdings = xlsread(filename,'B:B');
terms = xlsread(filename,'C:C');
Names=[];
Maturity=[];
for idx=1:length(terms)
      Names= [Names;strcat('Bond',int2str(terms(idx,1)))];
      Maturity = [Maturity;round(datenum(year(Settle)+ terms(idx,1),month(Settle),day(Settle)))];
end
t1=datedisp( Maturity);
Period = 1;
InstSet = instadd('Bond', CouponRate, Settle, t1, Period);
InstSet = instsetfield(InstSet, 'Index',1:4, 'FieldName', {'Quantity'}, 'Data', Holdings );
InstSet = instsetfield(InstSet, 'Index',1:4, 'FieldName', {'Name'}, 'Data', Names );
instdisp(InstSet);
%f = msgbox(sprintf(InstSet));
[Price, PTree] = bkprice(BKTree, InstSet);
%treeviewer(PTree);

end