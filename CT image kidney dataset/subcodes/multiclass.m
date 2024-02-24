function multiclass(biggestBlob)
  
  ntot = numel(biggestBlob);
  nblack = length( biggestBlob(biggestBlob~=0) );
  nwhite=ntot-nblack
  
  if nwhite>40000
    h = msgbox('Abnormalities detected!!','Kindney stone present','error');
   h1 = msgbox(' Kindney stone present');
else if nwhite>38000
    h = msgbox('Abnormalities detected!!','kidney cyst present','error');
    h1 = msgbox(' kidney cyst present');
   
    else if nwhite>35000
        h = msgbox('Abnormalities detected!!','Kidney tumor present','error');
    h1 = msgbox('Kidney tumor present');
        
        else
        h = msgbox('No Abnormalities detected!!','No symptoms for kidney diseases');
    h1 = msgbox('No symptoms for kidney diseases');
    end
    end
end