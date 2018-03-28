parameters
    NGpriceCap(NGm,NGw,r) price caps in million USD per BCM
        /
$INCLUDE build/data/NGpriceCap.inc
        /
    NGomCost(NGt,NGs,r) marginal production cost in $ per cm
        /
$INCLUDE build/data/NGomCost.inc
        /
    NGcapitalCost(NGt,NGs,r) annualzied investment cost for each field
        /
$INCLUDE build/data/NGcapitalCost.inc
        /
    NGpartner(NGi,NGs) partern shares in each asset NGs
        /
$INCLUDE build/data/NGpartner.inc
        /
    NGtransexist(NGi,r,rr) pipeline capacity
        /
$INCLUDE build/data/NGtransexist.inc
        /
* Fix duplicate values (need average length)
    NGtransexistlen(r,rr) pipeline length
        /
$INCLUDE build/data/NGtransexistlen.inc
        /
    NGregasexist(NGi,r) natural gas regasification infrastructure
        /
$INCLUDE build/data/NGregasexist.inc
        /
    NGplateau(NGs,NGt,r) production horizon for each field
        /
$INCLUDE build/data/NGplateau.inc
        /
    NGlifetime(NGt,NGs,r) production lifetime for each asset
        /
$INCLUDE build/data/NGlifetime.inc
        /
    NGregasCapitalCost(NGi,r)
        /
$INCLUDE build/data/NGregasCapitalCost.inc
        /
    NGdemand(NGm,r) fixed gas demand in each region
        /
$INCLUDE build/data/NGdemand.inc
        /
    NGquota(NGi,NGm,NGW,r) supply quotas when price cap is binding
        /
$INCLUDE build/data/NGquota.inc
        /
    NGprod2015(r) supply quotas when price cap is binding
        /
$INCLUDE build/data/NGprod2015.inc
        /
    NGfuelpflag(NGm,NGw,r)
    NGtransOM(NGw,r,rr)
* TO-DO: Update transport costs per km
    NGtransCost(NGw) marginal transportation cost mm$ per bcm per km
        /
            pipe    0.002103
            LNG     0.0118
        /
    NGtransCapitalCost(r,rr)
    NGimportContract(NGi,NGw) Fixed Pipeline Import contracts
        /
            CNPC.pipe   33.66
            CNPC.lng    6.03
            CNOOC.lng   18.46
            Sinopec.lng 2.186
            Other.lng   0.5244
        /
    NGimportPrice(NGi,NGw) natural gas import price mm$ per bcm for contracts
        /
            CNPC.pipe  285.8
            CNPC.lng 379.3
            CNOOC.lng 273.3
            Sinopec.lng 397.3
            Other.lng 349.9
        /
   NGliqueexist(NGi,r) liquefaction existing capacity
        /
$INCLUDE build/data/NGliqueexist.inc
        /
   NGliqueCapitalCost(NGi,r) liquefaction cost
        /
$INCLUDE build/data/NGliqueCapitalCost.inc
        /
    NGdemLNG(r)
        /
Beijing 0.804747537
Tianjin 0.435287622
Hebei   1.489141865
Shanxi  3.092833104
'Inner Mongolia' 1.935884424
Liaoning    1.248588179
Jilin   0.019091562
Heilongjiang    0
Shanghai    0.30928331
Jiangsu 3.833585724
Zhejiang    0.007636625
Anhui   1.88242805
Fujian  0.580383496
Jiangxi 0
Shandong    1.917525978
Henan   2.733911731
Hubei   2.707183544
Hunan   0.749275093
Guangdong   1.176040242
Guangxi 0.301646685
Hainan  1.023307743
Chongqing   2.88664423
Sichuan 2.23753111
Guizhou 0.534563746
Yunnan  0
Shaanxi 1.245182244
Gansu   1.069127493
Qinghai 0.731359571
Ningxia 1.240951554
Xinjiang    3.806857536
        /
    NGa(NGm,r) intercept of inverse demand curve
    NGb(NGm,r) slope of the inverse demand curve
    NGe(NGm,r) price elasticity
;
*   Re-scale demand to match 191.5 based on SIA data
    NGdemand(NGm,r)=NGdemand(NGm,r)*0.958;
    NGdemand(NGm,'Heilongjiang')= NGdemand(NGm,'Heilongjiang')/0.94;
    NGdemand(NGm,'Shaanxi')= NGdemand(NGm,'Shaanxi')/0.958;
    NGdemand('CityGate','Qinghai')= NGdemand('CityGate','Qinghai')*0.92;

* Rescale quota for city gate to make room for more unregualted LNG supplies (at least 18)
    NGquota(NGi,'CityGate','pipe',r)$(sum(NGii,NGquota(NGii,'CityGate','pipe',r))>0) =
    NGquota(NGi,'CityGate','pipe',r)/sum(NGii,NGquota(NGii,'CityGate','pipe',r))*
    (NGdemand('CityGate',r) - 10*NGdemand('CityGate',r)/sum(rr,NGdemand('CityGate',rr)))
;

    NGdemand(NGm,r)$(NGdemand(NGm,r)<1e-4 and sum(NGmm,NGdemand(NGm,r))>0) = 1e-4;
*Qinghai

    NGimportPrice(NGi,lng) = 410;
    NGiwR(NGi,"pipe","Imports Asia")$(NGimportPrice(NGi,'pipe')>0)=yes;
*   enforce contracts to pipeline imports only
    NGiwR(NGi,"lng",r)$(NGimportPrice(NGi,'lng')>0 and NGrILng(r))=yes;

    loop(r,NGiw(NGi,pipe)$NGiwR(NGi,pipe,r)=yes);

*   convert from % to frac
    NGpartner(NGi,NGs)=NGpartner(NGi,NGs)/100;
*   assume CMM and CBM are owned and oeprated by other suppliers
    loop(r,NGpartner('Other',NGs)$NGts("CBM",NGs,r)=1);
    loop(r,NGpartner('Other',NGs)$NGts("CMM",NGs,r)=1);
    NGtransCapitalCost(r,rr)=0;
scalar
    NGliqCost additional cost for liquifying gas in USD per kcm /41/
    NGregasCost regasification operationg cost USD per kcm /15/
    NGtransLoss percent loss when transporting gas per km /0.00002/
    NGregasYield percent loss for regasificatino and injection /0.986/
    NGliqYield percent loss for liquefaction /0.88/
;

*   Calibration 2015 production
    NGprod2015('Tianjin')=0;
    NGprod2015('Shandong')=0;
    NGprod2015('Guangdong')=0;
    NGprod2015('Hebei')=0;
    NGprod2015('Hainan')=0;
    NGplateau(NGs,NGt,r)$(NGprod2015(r)>0 and sum((NGss,NGtt),NGplateau(NGss,NGtt,r))>0)
    = NGplateau(NGs,NGt,r)*NGprod2015(r)/sum((NGss,NGtt),NGplateau(NGss,NGtt,r))
;
*   CMM is considered free gas.
    NGomCost('CMM',NGs,r)=0
;
    NGomCost('CBM',NGs,r)=79.7
;
    NGcapitalCost('CMM',NGs,r)=0
;
* Drop VAT from import prices
    NGpriceCap('Chemical','pipe',r)=136.4804/1.13
;
    NGpriceCap('CityGate','pipe',r)=NGpriceCap('CityGate','pipe',r)/1.13
;
    NGomCost(NGt,NGs,r)=NGomCost(NGt,NGs,r);
;
    NGcapitalCost(NGt,NGs,r)=NGcapitalCost(NGt,NGs,r)
;
    NGtransexistlen(r,rr)$(NGtransexistlen(rr,r)>NGtransexistlen(r,rr)) = NGtransexistlen(rr,r)
;
    NGtransOM(NGw,r,rr)=NGtransCost(NGw)*NGtransexistlen(r,rr)
;