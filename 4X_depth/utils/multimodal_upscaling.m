function [Alphay] = multimodal_upscaling( Y,weight)
   
   	 					
		[~,H]=size(Y); h=floor(H/2);				
		PP=weight.We;
        b0_1 = PP * Y(:,1:h);
                
        M_1=Y(:,1:h)-weight.D1*b0_1;         
        Tem1=b0_1+weight.P1*M_1; clear b0_1 M_1;               
        theta1=repmat((weight.lam1)', h, 1); %43225*512           
        b1_1 = wthresh(Tem1,'s',theta1'); clear  Tem1 theta1 ;
        
         
        b0_2 = PP * Y(:,(h+1):end); clear PP;
        M_2=Y(:,(h+1):end)-weight.D1*b0_2;
        Tem2=b0_2+weight.P1*M_2;
        clear b0_2 M_2;      
        theta2=repmat((weight.lam1)', (H-h), 1); %43225*512                               
        b1_2 = wthresh(Tem2,'s',theta2'); 
        clear Tem2 theta2;
       
  %%%%%%%%%%%%%%%%     
       
        M_1=Y(:,1:h)-weight.D2*b1_1;                 
        Tem1=b1_1+weight.P2*M_1; clear M_1  b1_1;
        theta1=repmat((weight.lam2)', h, 1);                
        b1_1 = wthresh(Tem1,'s',theta1'); clear  Tem1 theta1 ;
        
        
        M_2=Y(:,(h+1):end)-weight.D2*b1_2; 
        Tem2=b1_2+weight.P2*M_2;
        clear M_2 b1_2;              
        theta2=repmat((weight.lam2)', (H-h), 1);  
        b1_2 = wthresh(Tem2,'s',theta2'); clear Tem2 theta2;
  %%%%%%%%%%%%%%%%%%%%%%%%
  
        M_1=Y(:,1:h)-weight.D3*b1_1;                 
        Tem1=b1_1+weight.P3*M_1; clear M_1  b1_1;
        theta1=repmat((weight.lam3)', h, 1);                
        b1_1 = wthresh(Tem1,'s',theta1'); clear  Tem1 theta1 ;
        
        
        M_2=Y(:,(h+1):end)-weight.D3*b1_2; 
        Tem2=b1_2+weight.P3*M_2;
        clear M_2 b1_2;              
        theta2=repmat((weight.lam3)', (H-h), 1);  
        b1_2 = wthresh(Tem2,'s',theta2'); clear Tem2 theta2;
   %%%%%%%%%%%%%%%%%%%%%%%%
   
        M_1=Y(:,1:h)-weight.D4*b1_1;                 
        Tem1=b1_1+weight.P4*M_1; clear M_1  b1_1;
        theta1=repmat((weight.lam4)', h, 1);                
        b1_1 = wthresh(Tem1,'s',theta1'); clear  Tem1 theta1 ;
        
        
        M_2=Y(:,(h+1):end)-weight.D4*b1_2; 
        Tem2=b1_2+weight.P4*M_2;
        clear M_2 b1_2;              
        theta2=repmat((weight.lam4)', (H-h), 1);  
        b1_2 = wthresh(Tem2,'s',theta2'); clear Tem2 theta2;
   
        
        Alphay = [b1_1,b1_2]; clear Y b1_1 b1_2;
                                 						              

end

