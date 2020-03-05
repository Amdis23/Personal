
function imf = emd(x)
c = x(:)'; 
N = length(x);
imf = []; 
while (1) 
   h = c; 
   SD = 1; 
   while SD > 0.2
      d = diff(h); 
      maxmin = []; 
      for i=1:N-2
         if d(i)==0                        
            maxmin = [maxmin, i];
         elseif sign(d(i))~=sign(d(i+1))   
            maxmin = [maxmin, i+1];        
         end
      end
      if size(maxmin,2) < 2
         break
      end
      if maxmin(1)>maxmin(2)             
         maxes = maxmin(1:2:length(maxmin));
         mins  = maxmin(2:2:length(maxmin));
      else                               
         maxes = maxmin(2:2:length(maxmin));
         mins  = maxmin(1:2:length(maxmin));
      end 
      maxes = [1 maxes N];
      mins  = [1 mins  N];
      maxenv = spline(maxes,h(maxes),1:N);
      minenv = spline(mins, h(mins),1:N); 
      m = (maxenv + minenv)/2; 
      prevh = h; 
      h = h - m;
      eps = 0.0000001;
      SD = sum ( ((prevh - h).^2) ./ (prevh.^2 + eps) ); 
   end
   imf = [imf; h];
   if size(maxmin,2) < 1
      break
   end 
   c = c - h;   
end
return