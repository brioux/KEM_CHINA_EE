Variables
    z
    NGobjval(NGi)  objective value of each firm
    NGcosts(NGi) costs of each firm
    NGprofit(NGi) profits of each firm

    NGtransP(NGw,NGii,r,rr) price for accessing companies transportation infrastructure (defined as the amrginal value)
;

Positive Variables
    NGop(NGi,NGt,NGs,NGw,r) natural gas produced for each field and state (liquid or gas)
    NGimport(NGi,NGw,r) naturagl gas imports by type
    NGsupply(NGi,NGm,NGw,r) delivery of gas to market
    NGsupplyQ(NGm,NGw,r) supplies delivered under capped prive quota
    NGexist(NGi,NGt,NGs,r) existing production capacity
    NGbld(NGi,NGt,NGs,r) investment in new production capacity
    NGbldliq(NGi,r) investment in new liquefication capacity
    NGtrans(NGi,NGw,NGii,r,rr) transport of natural gas by type. For gas Firm NGi moves gas on pipelin owned by NGii
    NGtransbld(NGi,r,rr) new transporation capacity built by firm NGi
    NGz(NGm,NGw,r) impact of the price cap on the generators revenues (slack variable)
    NGp(r) market clearing price
    DNGtranscaplim(NGw,NGii,r,rr) marginal value on a firms pipeline
    NGregas(NGi,r) firm decision to regasify and inject into pipeline
    NGregasBld(NGi,r) new build regas infrastructure
    NGdemandV(NGm,r)

    DNGdem(r)
    DNGdem_m(NGm,r)
;

* fix firms existing natural gas assets using partner shares. Undeveloped assets set to 0 (goverened by firm build decision)
NGexist.fx(NGi,NGt,NGs,r)$(NGts(NGt,NGs,r)) = 0;
NGexist.fx(NGi,NGt,NGs,r)$(NGts(NGt,NGs,r)) = NGplateau(NGs,NGt,r)*NGpartner(NGi,NGs);
*NGsupply.up(NGi,'CityGate','lng',r)=0;
NGtransbld.up(NGi,r,rr)=0;
NGbldliq.up(NGi,r)=0;
*NGtrans.up(NGi,'lng',NGi,r,rr)$NGconnect(r,rr) = 1;
*NGtrans.up(NGi,'pipe',NGii,r,rr)$(NGconnect(r,rr) and ord(NGi)<>ord(NGii)) = 0;
