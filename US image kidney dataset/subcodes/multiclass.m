function multiclass(biggestBlob)
  
  ntot = numel(biggestBlob);
  nblack = length( biggestBlob(biggestBlob~=0) );
  nwhite=ntot-nblack;
  
  if nwhite>40000
    h = msgbox('Abnormalities detected!!',' Chronic Kindney disease present','error');
   h = msgbox(' Chronic Kindney disease present');
else if nwhite>38000
    h = msgbox('Abnormalities detected!!','Diabetic kidney disease present','error');
    h = msgbox('Diabetic kidney disease present');
   
    else if nwhite>36000
        h = msgbox('Abnormalities detected!!','Glomerular Disease present','error');
    h = msgbox('Glomerular Disease present');
        else
            h = msgbox('No Abnormalities detected!!');
    h = msgbox('No Symptoms for kidney Disease ');
        end
    end
end