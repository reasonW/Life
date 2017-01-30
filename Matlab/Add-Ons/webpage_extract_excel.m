 t = regexp(webread('http://ecorr.org/ecorr/dataSharedetail-1295-73.html'),...
    '<table[^>]*>(.*?)</table>','tokens');
t = [t{end-11:end}];
head = strtrim(regexp(t,'(?<=<b>)([^<]*)','match'));
data = strtrim(regexp(t,'(?<=<td>)([^<]*)','match'));
[u,~,id] = unique([head{:}],'stable');
k = mat2cell(id,cellfun('prodofsize',head),1);

t = cell2table(data{1},'var',sprintfc('v%d',k{1}));
for i = 2:numel(k)
    t = outerjoin(t,cell2table(data{i},'var',sprintfc('v%d',k{i})),'merge',1);
end
xlswrite('data.xlsx',[u; t{:,:}])