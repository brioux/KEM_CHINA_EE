$ontext
An equilibirum model of natural gas supply
$offtext
$inlinecom /* */
$INCLUDE  src\sets\natgas.gms
$INCLUDE  src\data\natgas.gms
$INCLUDE  src\variables\natgas.gms

*Flag for setting scenario with price caps
    NGfuelpflag(NGm,NGw,r) = 1; /* Marginal Value*/
    NGfuelpflag("Citygate",'pipe',r)= 4; /* Price Cap */
    NGfuelpflag("Chemical",'pipe',r)= 4; /* Price Cap */
scalar TPA set to 1 for Third Party Access to pipielines /0/
;

* Set price to marginal value if price cap is not positive
NGfuelpflag(NGm,NGw,r)$(NGpriceCap(NGm,NGw,r)<=0 and NGfuelpflag(NGm,NGw,r)=4)=1;

scalar priceCapFlag flag if price caps are present /0/;
loop((NGm,NGw,r)$(NGfuelpflag(NGm,NGw,r)=4), priceCapFlag=1);

$INCLUDE  src\equations\natgasmodel.gms


parameters report;
report(NGi,"Production (pipeline)") = sum((NGt,NGs,pipe,r),NGop.l(NGi,NGt,NGs,pipe,r)) ;
report(NGi,"Production (LNG)")      = sum((NGt,NGs,LNG,r),NGop.l(NGi,NGt,NGs,LNG,r)) ;
report(NGi,"Onshore Conventional") = sum((NGs,NGw,r),NGop.l(NGi,'conventional',NGs,NGw,r)) ;
report(NGi,"Offshore") = sum((NGs,NGw,r),NGop.l(NGi,'offshore',NGs,NGw,r)) ;
report(NGi,"Uncoventional") = sum((NGs,NGw,r),NGop.l(NGi,'unconventional',NGs,NGw,r)) ;
report(NGi,"CBM") = sum((NGs,NGw,r),NGop.l(NGi,'CBM',NGs,NGw,r)) ;
report(NGi,"CMM") = sum((NGs,NGw,r),NGop.l(NGi,'CMM',NGs,NGw,r)) ;
report(NGi,"Pipeline Imports (bcm)") = sum((pipe,r),NGimport.l(NGi,pipe,r));
report(NGi,"LNG Imports (bcm)") = sum((LNG,r),NGimport.l(NGi,LNG,r));
report(NGi,"Pipeline Movements (bcm-km)") = sum((NGii,pipe,r,rr),NGtrans.l(NGi,pipe,NGii,r,rr)*NGtransexistlen(r,rr)) ;
report(NGi,"LNG Shipments (bcm-km)") = sum((NGii,LNG,r,rr),NGtrans.l(NGi,LNG,NGii,r,rr)*NGtransexistlen(r,rr)) ;


report(NGi,"Costs") = NGcosts.l(NGi);
report("Total","Costs") = sum(NGi,report(NGi,"Costs"));
report("Total","LNG Imports (bcm)") = sum(NGi,report(NGi,"LNG Imports (bcm)"));
report("Total","Pipeline Imports (bcm)") = sum(NGi,report(NGi,"Pipeline Imports (bcm)"));
report("Total","Production (pipeline)") = sum(NGi,report(NGi,"Production (pipeline)"));
report("Total","Production (LNG)")      = sum(NGi,report(NGi,"Production (LNG)")) ;
report("Total","Onshore Conventional") =  sum(NGi,report(NGi,"Onshore Conventional")) ;
report("Total","Offshore") =  sum(NGi,report(NGi,"Offshore")) ;
report("Total","Uncoventional") = sum(NGi,report(NGi,"Uncoventional")) ;
report("Total","CBM") = sum(NGi,report(NGi,"CBM")) ;
report("Total","CMM") = sum(NGi,report(NGi,"CMM")) ;
report("Total","Pipeline Movements (bcm-km)") = sum(NGi,report(NGi,"Pipeline Movements (bcm-km)"));
report("Total","LNG Shipments (bcm-km)") = sum(NGi,report(NGi,"LNG Shipments (bcm-km)"));
report("Total","Total production cost") =SUM((r,NGt,NGs,NGw,NGi)$(NGts(NGt,NGs,r) and NGtw(NGi,NGt,NGw)), (NGomCost(NGt,NGs,r)+NGliqCost$lng(NGw))*NGop.l(NGi,NGt,NGs,NGw,r));
report("Total","Total import cost") =sum((NGi,NGw,r)$NGiwR(NGi,NGw,r),NGimportPrice(NGi,NGw)*NGimport.l(NGi,NGw,r));
report("Total","Total transport cost") =sum((NGi,NGii,NGw,r,rr)$NGc(NGii,NGw,NGi,r,rr),NGtransOM(NGw,r,rr)*NGtrans.l(NGii,NGw,NGi,r,rr));
report("Total","Total regas cost") =sum((NGi,r),NGregasCapitalCost(NGi,r)*NGregasBld.l(NGi,r))+sum((NGi,r),NGregasCost*NGregas.l(NGi,r));
report("Total","Total liq capa cost") =SUM((NGi,r,NGt,NGs)$(NGts(NGt,NGs,r) and NGsD(NGs)),NGcapitalCost(NGt,NGs,r)*NGbld.l(NGi,NGt,NGs,r));

report("Total","Total profit NOC") =sum(NGi$NOC(NGi),NGprofit.l(NGi));
report("Total","Total costs NOC") =sum(NGi$NOC(NGi),NGcosts.l(NGi)
    +sum((NGii,NGw,r,rr)$(NGc(NGi,NGw,NGii,r,rr) and ord(NGii)<>ord(NGi) and pipe(NGw)),
        NGtransP.l(NGw,NGii,r,rr)*NGtrans.l(NGi,NGw,NGii,r,rr)
    )
);
report("Total","Total profit Other") =sum(NGi$(not NOC(NGi)),NGprofit.l(NGi));
report("Total","Total costs Other") =sum(NGi$(not NOC(NGi)),NGcosts.l(NGi)
    +sum((NGii,NGw,r,rr)$(NGc(NGi,NGw,NGii,r,rr) and ord(NGii)<>ord(NGi) and pipe(NGw)),
        NGtransP.l(NGw,NGii,r,rr)*NGtrans.l(NGi,NGw,NGii,r,rr)
    )
);