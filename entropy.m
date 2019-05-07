function s=entropy(senyal,num)
h=histogram(senyal,2^num,'Normalization','probability');
s=0;
for i = 1:length(h.Values) 
    s=s+h.Values(i)*log2(h.Values(i));
end
end
