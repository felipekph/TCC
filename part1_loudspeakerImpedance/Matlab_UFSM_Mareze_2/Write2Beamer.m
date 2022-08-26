%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Código para escrever slides de Beamer para LaTeX
%
% Desenvolvido pelo professor da Engenharia Acústica 
%                                William D'Andrea Fonseca, Dr. Eng.
%
% Última atualização: 21/09/2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all;

feature('DefaultCharacterSet', 'UTF8');
% feature('DefaultCharacterSet', 'ISO-8859-1');
%% Procura arquivos

files = look_for_files('pdf','D:\Meus Documentos\Google Drive\EAC-Projeto-Embraer\Resultados\TL antigo');

%% Open header
ID = fopen('exp.txt','r');
header0 = textscan(ID,'%s','Delimiter','\r');

%% Write frames  - Copia
fileID = fopen('D:\Meus Documentos\Google Drive\EAC-Projeto-Embraer\Resultados\Latex\TL-velho.tex','wt+');
fprintf(fileID, '\\section{TL antigo}\n\n');
for a=1:size(files.subs,1)
if ~isempty(files.subs{a,1}) 
  for b=1:size(files.subs{a,2},1); pts='';
    [~,names,~] = fileparts(files.subs{a,2}{b,1}); snome = size(names,2); if snome>102; snome=102; pts='...'; end;
    fprintf(fileID, '%s\n',header0{1,1}{1,1});
    fprintf(fileID, '\\frame{\\frametitle{\\tiny\\directory{%s}}\n', strcat(names(1:snome),pts));
%     fprintf(fileID, '%s\n', header0{:}{4:5});
    fprintf(fileID, '\\begin{figure}[H]\n\\centering\n');
    fprintf(fileID, '\\includegraphics[width=0.90\\columnwidth]{%s}\n\n', files.subs{a,3}{b,1});    
%     fprintf(fileID, '}\\\\[2pt]\n');
    fprintf(fileID, '\\vspace{2mm}\\tiny\\directory{%s}\n', strrep(files.subs{a,1}(33:end),'\','/'));
    fprintf(fileID, '\\end{figure}\n}\n\n');
  end
end
if ~isempty(files.subssub{a,1}) 
  for c=1:size(files.subssub,1)      % Processa subs-sub
   for d=1:size(files.subssub{c,2},1); pts='';
    [~,names,~] = fileparts(files.subssub{c,2}{d,1}); snome = size(names,2); if snome>102; snome=102; pts='...'; end;
    fprintf(fileID, '%s\n',header0{1,1}{1,1});
    fprintf(fileID, '\\frame{\\frametitle{\\tiny\\directory{%s}}\n', strcat(names(1:snome),pts));
%     fprintf(fileID, '%s\n', header0{:}{4:5});
    fprintf(fileID, '\\begin{figure}[H]\n\\centering\n');
    fprintf(fileID, '\\includegraphics[width=0.90\\columnwidth]{%s}\n\n', files.subssub{c,3}{d,1});    
%     fprintf(fileID, '}\\\\[2pt]\n');
    fprintf(fileID, '\\vspace{2mm}\\tiny\\directory{%s}\n', strrep(files.subssub{c,1}(33:end),'\','/'));
    fprintf(fileID, '\\end{figure}\n}\n\n');
    end
   end     
 end  
end    
fclose('all');