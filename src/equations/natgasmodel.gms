Equations
    NGobjective, NGobjectiveFirm(NGi) ,NGcostEqn(NGi), NGprofitEqn(NGi)
    NGpriceCapSlack(NGm,NGw,r) constraint for the slack variable - diff market price and price cap
    NGquotaEqn(NGm,NGw,r) constraint enforcing quotas on deliveries when the price is binding
    NGcaplim(NGi,NGt,NGs,r) gas field production limit
    NGbldPartner(NGi,NGt,NGs,r) gas field capacity horizon
    NGsup(NGi,NGw,r) transportation supply balance
    NGtransCapLim(NGw,NGi,r,rr) transport capacity limit (pipe and trucked lng)
    NGdem(r) demand equation by market segment
    NGdem_m(NGm,r)
    NGliqCaplim(NGi,r) liqueficaiton capacity limit
    NGtransPricEqn(NGw,NGii,r,rr)
    NGregasLim(NGi,r) capacity limit for regasification of LNG
    NGliqueLim(NGi,r) capacity limit for liquefaction of LNG
    NGimportEqn(NGi,NGw) pipeline import contracts
    NGsupEnforce(NGm,NGw,r) Demand equation to meet quata levels with no cap under a global system optimization scenario
    NGdemResponse(NGm,r)
    NGtransbarrier(NGi,NGii,r,rr)
    NGprice_eqn(NGm,r)
;
**************************************
* Abstract: Objective function for global optimization
* Precondition: calculate firm costs
* Postcondition: Total system costs for natural gas supply
**************************************
NGobjective..
    z =e=
*    sum(r,NGp(r))
*    -sum((NGi,NGm,NGw,r),NGsupply(NGi,NGm,NGw,r)*NGp(r))
    +sum(NGi,NGcosts(NGi))
*   Add this below if Z is to be considered
    +sum((NGi,NGm,NGw,r),NGsupply(NGi,NGm,NGw,r)*NGz(NGm,NGw,r)$(NGfuelpflag(NGm,NGw,r)=4))
;
**************************************
* Abstract: Objective function for firm lvel optimization
* Precondition: Total systesm costs and lost market value if price cap enforced
* Postcondition: Total systems cost including lost reveneu under price cap (provides firm incentive to switch to devliery modes without price cap)
**************************************
NGobjectiveFirm(NGi)..
    NGobjval(NGi) =e=
    +sum((NGm,NGw,r),
        +NGsupply(NGi,NGm,NGw,r)*NGz(NGm,NGw,r)$(NGfuelpflag(NGm,NGw,r)=4))
    +sum((NGii,NGw,r,rr)$(NGc(NGi,NGw,NGii,r,rr) and ord(NGii)<>ord(NGi) and pipe(NGw)),
        NGtransP(NGw,NGii,r,rr)*NGtrans(NGi,NGw,NGii,r,rr)
    )
    +NGcosts(NGi)
;
**************************************
* Abstract: Firm level profit equation
* Precondition: Costs, Supply quantities (regular allocated)
* Postcondition: Total profits
**************************************
NGprofitEqn(NGi)..
    NGprofit(NGi) =e=
    +sum((NGm,NGw,r),
       +NGsupply(NGi,NGm,NGw,r)*(NGp(r)-NGz(NGm,NGw,r)$(NGfuelpflag(NGm,NGw,r)=4))
    )
    +sum((NGii,NGw,r,rr)$(NGc(NGii,NGw,NGi,r,rr) and ord(NGii)<>ord(NGi) and pipe(NGw)),
        NGtransP(NGw,NGi,r,rr)*NGtrans(NGii,NGw,NGi,r,rr)
    )
    -NGcosts(NGi)
    -sum((NGii,NGw,r,rr)$(NGc(NGi,NGw,NGii,r,rr) and ord(NGii)<>ord(NGi) and pipe(NGw)),
        NGtransP(NGw,NGii,r,rr)*NGtrans(NGi,NGw,NGii,r,rr)
    )
;
**************************************
* Abstract: Firm level cost euquation
* Precondition: All firm activities
* Postcondition: Total system cost by firm
**************************************
NGcostEqn(NGi).. NGcosts(NGi) =e=
    +sum((NGw,r)$NGiwR(NGi,NGw,r),NGimportPrice(NGi,NGw)*NGimport(NGi,NGw,r))
    +SUM((r,NGt,NGs)$(NGts(NGt,NGs,r) and NGsD(NGs)),NGcapitalCost(NGt,NGs,r)*NGbld(NGi,NGt,NGs,r))
    +SUM((r,NGt,NGs,NGw)$(NGts(NGt,NGs,r) and NGtw(NGi,NGt,NGw)),
            (NGomCost(NGt,NGs,r)+NGliqCost$lng(NGw))*NGop(NGi,NGt,NGs,NGw,r)
    )
    +sum((NGii,NGw,r,rr)$NGc(NGii,NGw,NGi,r,rr),
        NGtransOM(NGw,r,rr)*NGtrans(NGii,NGw,NGi,r,rr)
    )
    +sum((NGii,NGw,r,rr)$NGconnect(r,rr),
        NGtransCapitalCost(r,rr)*NGtransBld(NGii,r,rr)
    )
    +sum(r,NGregasCapitalCost(NGi,r)*NGregasBld(NGi,r))
    +sum(r,NGregasCost*NGregas(NGi,r))
    +sum(r,NGliqueCapitalCost(NGi,r)*NGbldliq(NGi,r))

;
**************************************
* Abstract: Pipeline stransportation value
* Precondition: Only for regions with predefined connection and for pipelines not owned by firm sending the gas.
* Postcondition: Sets price paid for firms senduing gas on a pipeline
**************************************
NGtransPricEqn(NGw,NGii,r,rr)$(NGconnect(r,rr) and pipe(NGw))..
   NGtransP(NGw,NGii,r,rr) =e=
*   DNGtranscaplim(NGw,NGii,r,rr)
   +NGtransOM(NGw,r,rr)*1.08
;
**************************************
* Abstract: Natural gas production constraint
* Precondition: Exisisting asset capacities owned by each firm
* Postcondition: Cap on asset produciton
**************************************================================================
NGcaplim(NGi,NGt,NGs,r)$NGts(NGt,NGs,r)..
    NGbld(NGi,NGt,NGs,r)$NGsD(NGs)+NGexist(NGi,NGt,NGs,r)$NGsD(NGs)-sum(NGw$NGtw(NGi,NGt,NGw),NGop(NGi,NGt,NGs,NGw,r)) =g= 0
;
**************************************
* Abstract: Plateau for natrual gas field assets
* Precondition: Predefined production plateau. Non-operational assets (Discovery, Appraisal etc ...)
* Postcondition: Distribute build activity accross firms
**************************************===================================================================
NGbldPartner(NGi,NGt,NGs,r)$(NGts(NGt,NGs,r) and NGsD(NGs))..
    -NGbld(NGi,NGt,NGs,r)-NGexist(NGi,NGt,NGs,r) =g=
    -NGplateau(NGs,NGt,r)*NGpartner(NGi,NGs)
;
**************************************
* Abstract: Liquefaction cosntraint
* Precondition: Existing regasification capacity
* Postcondition: Bounded regasification capacity
**************************************
NGliqueLim(NGi,r)..
sum(NGii,NGliqueexist(NGii,r))+NGbldliq(NGi,r) =g=
 sum((NGt,NGs)$(NGts(NGt,NGs,r) and NGtw(NGi,NGt,'lng')),NGop(NGi,NGt,NGs,'lng',r))
;
**************************************
* Abstract: Regasification cosntraint
* Precondition: Existing regasification capacity
* Postcondition: Bounded regasification capacity
**************************************
NGregasLim(NGi,r)..
NGregasexist(NGi,r)+NGregasbld(NGi,r) =g= sum(NGii$(TPA=1 or (ord(NGii)<>ord(NGi))),NGregas(NGii,r))
;
**************************************
* Abstract: Supply balance
* Precondition:
* Postcondition: balanced supplies by region and delivery mode (LNG and pipe)
**************************************
NGtransbarrier(NGi,NGii,r,rr)$(NGc(NGii,'pipe',NGi,r,rr) and ord(NGi)<>ord(NGii) and  TPA<>1 and not r_offshore(r))..
    (NGtransexist(NGii,r,rr)+NGtransbld(NGii,r,rr))*0.01
    -NGtrans(NGi,'pipe',NGii,r,rr)
    =g=0
;

NGsup(NGi,NGw,r)..
    +NGimport(NGi,NGw,r)$NGiwR(NGi,NGw,r)
    +sum((NGt,NGs)$(NGts(NGt,NGs,r) and NGtw(NGi,NGt,NGw)),NGop(NGi,NGt,NGs,NGw,r)*(1$pipe(NGw)+NGliqYield$lng(NGw)))
    +sum((NGii,rr)$NGc(NGi,NGw,NGii,rr,r),NGtrans(NGi,NGw,NGii,rr,r)*(1-NGtransLoss*NGtransexistlen(r,rr)))
    +NGregas(NGi,r)*NGregasYield$pipe(NGw)
    =g=
    +NGregas(NGi,r)$lng(NGw)
    +sum((NGii,rr)$NGc(NGi,NGw,NGii,r,rr),NGtrans(NGi,NGw,NGii,r,rr))
    +sum(NGm,NGsupply(NGi,NGm,NGw,r)
*        +NGsupplyQ(NGi,NGm,NGw,r)$(NGfuelpflag(NGm,NGw,r)=4)
        )
;
**************************************
* Abstract: Transporation capacity limit
* Precondition: Connected regions
* Postcondition: total gas tranported by firm i by pipeline
**************************************
NGtransCapLim(NGw,NGi,r,rr)$(NGconnect(r,rr) and pipe(NGw))..
    NGtransexist(NGi,r,rr)+NGtransbld(NGi,r,rr)
    -sum(NGii$NGc(NGii,NGw,NGi,r,rr),NGtrans(NGii,NGw,NGi,r,rr))
    =g=0
;
**************************************
* Abstract: Natrual gas demand balance by market segment
* Precondition:
* Postcondition:
**************************************
NGdem_m(NGm,r)..
    sum((NGii,NGw),NGsupply(NGii,NGm,NGw,r))
    =g=NGdemand(NGm,r)
;
**************************************
* Abstract: Complementarity slackness for representing market segements with price cap
* Precondition: Fuel price flag set to price cap (4)
* Postcondition: Lost market value resulting from price cap
**************************************
NGpriceCapSlack(NGm,NGw,r)$(NGfuelpflag(NGm,NGw,r)=4)..
    NGz(NGm,NGw,r) =g= NGp(r) - NGpriceCap(NGm,NGw,r)
;
**************************************
* Abstract: Regulated market link
* Precondition: Dual on natural gas demand constraint (NGdem_m)
* Postcondition: Set free market price
**************************************
NGprice_eqn(NGm,r)..
 NGp(r) =g=  DNGdem_m(NGm,r)
;
**************************************
* Abstract: Contractual obligations of all natural gas suppliers. Corresponding quantity equation for complemntarity slackeness NGpriceCapSlack
* Precondition: Fuel price flag set to price cap (4)
* Postcondition: Enforce supply quotas when price is capped
**************************************
NGquotaEqn(NGm,NGw,r)$(NGfuelpflag(NGm,NGw,r)=4)..
 -NGsupplyQ(NGm,NGw,r) =g= -sum(NGi,NGquota(NGi,NGm,NGw,r))*0.5
* quota levels are adjusted to calibrate baseline scenario
;
**************************************
* Abstract: Equation enforces supply obligations on firm delivieries
* Precondition: Total volume of supply quota's. Fuel price flag set to price cap (4)
* Postcondition: Quotas distributed between all frims. Fair market price for quotas set by the margianl value
**************************************
NGsupEnforce(NGm,NGw,r)..
    sum(NGi$NOC(NGi),NGsupply(NGi,NGm,NGw,r))-NGsupplyQ(NGm,NGw,r)$(NGfuelpflag(NGm,NGw,r)=4)=g=0;
;
**************************************
* Abstract: Natrual gas pipeline import contracts
* Precondition: Sett the lower bound represeting pipeline improts
* Postcondition: Enforce minimum imports by pipieline for all suppliers
**************************************
NGimportEqn(NGi,NGw)$NGiw(NGi,NGw)..
    sum(r$NGiwR(NGi,NGw,r),NGimport(NGi,NGw,r)) =g= NGimportContract(NGi,NGw)
;

********************************************************************************************************
model NGequations
    /NGcostEqn, NGpriceCapSlack,NGprofitEqn, NGquotaEqn, NGcaplim, NGbldPartner, NGsup,NGdem_m,NGtransbarrier,NGtransCapLim,
         NGregasLim,NGliqueLim, NGtransPricEqn, NGimportEqn, NGprice_eqn/
;
model NGglobalmin
    /NGobjective,NGsupEnforce,NGEquations/
;
*********************************************************************************************
option MCP=path
option NLP=pathnlp
;
file empinfo / '%emp.info%' /;

put empinfo 'DualVar DNGdem_m NGdem_m ';
put$(priceCapFlag=1) empinfo 'DualVar NGz NGquotaEqn';
put$(priceCapFlag=1) empinfo 'DualEqu NGpriceCapSlack NGsupplyQ ';
putclose empinfo / 'modeltype mcp'/;
NGglobalmin.optfile=1;
*Execute_Loadpoint 'results/reference.gdx';
solve NGglobalmin using EMP minimizing z;
