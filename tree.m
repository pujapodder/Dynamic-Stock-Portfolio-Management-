function BKTree= tree(Startdate,EndDates,Rate)
VDate = Startdate;
Compounding = 1;
RateSpec = intenvset('Compounding',Compounding,'StartDates', Startdate,'EndDates', EndDates, 'Rates', Rate,'ValuationDate', VDate);
Volatility = [0.01; 0.02; 0.03; 0.04; 0.05; 0.06; 0.07;0.08; 0.09; 0.1; 0.11; 0.12; 0.13; 0.14; 0.15; 0.16; 0.17];
Alpha = [0.01];
VolSpec = bkvolspec(VDate, EndDates, Volatility, EndDates(end), Alpha);
TimeSpec = bktimespec(VDate, EndDates);
BKTree = bktree(VolSpec, RateSpec, TimeSpec);
BKTreeR = cvtree(BKTree);
OldFormat = get(0, 'format');
format short;
RateRoot      = trintreepath(BKTreeR, 0);
RatePathUp    = trintreepath(BKTreeR, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
RatePathMiddle = trintreepath(BKTreeR, [2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2]);
RatePathDown = trintreepath(BKTreeR, [3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3]);
end