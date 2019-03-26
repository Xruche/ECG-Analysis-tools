function s=entropy(senyal)
h=histogram(senyal,'Normalization','probability');
s=0;
for i = 1:length(h.Values) 
    s=s+h.Values(i)*log(h.Values(i))/log(2);
end
end