function filepath = look_for_files(formato,filepath,subds)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Função para buscar arquivos de uma certa extensão em pastas e subpastas
% escreve ainda o caminho em formato para utlização no LaTeX 
%
% Desenvolvido pelo professor da Engenharia Acústica 
%                                William D'Andrea Fonseca, Dr. Eng.
%
% Última atualização: 21/09/2017
%
%
%%% Exemplo:
% files = look_for_files('pdf','D:\Meus Documentos\Google Drive')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2 || isempty(filepath) ; 
    error('Sorry, I cannot help you, have o look to the inputs')
end
if nargin < 3 || ~exist('subds','var') || isempty(subds); subds = 1; end
%% Test
% clear all; close all;
% formato = 'pdf'; filepath = 'D:\Meus Documentos\Google Drive\EAC-Projeto-Embraer\Resultados\Tubo de Impedancia - Novo'; subds = 1;

%% Let's do it!
%% Check path %% best use in Windows %%
if ~strcmp(filepath(end),'\')
   filepath = [filepath '\'];
% if ~strcmp(filepath(end),'/') %% Use this for Unix
%    filepath = [filepath '/'];
end
filepath.base = filepath;
%% Check format
if isempty(formato); error('Please define the format, for example, pdf.'); end
filepath.format = formato;
%% Verifica diretorio principal
PDFs_root = dir(strcat(filepath.base,'*.',formato));
filepath.files = [strcat(filepath.base,{PDFs_root.name})]';
for a=1:length(filepath.files)
 filepath.files{a,2} = strcat('{"',strrep(filepath.files{a,1}(1:end-4),'\','/'),'"}.',formato); %% Escreve path compatível com Latex
end
%% Verifica os subdiretorios
if subds == 1
d = dir(filepath.base);
if isempty(d)
    error('Have a look to the input path, I guess it does NOT EXIST.')
else
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];
end
%% Cria lista dos subs
for a=1:length(nameFolds)
 filepath.subs{a,1} = strcat(filepath.base,nameFolds{a},'\');
end     
%% Mapeia arquivos nos subs e se exite um novo subdiretorio
for a=1:length(nameFolds)
    d = dir(filepath.subs{a,1});
    pdf{a,1} = dir(strcat(filepath.subs{a,1},'*.',formato));
    isub = [d(:).isdir]; % Returns logical vector
    nameFolds = {d(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];
        filepath.subssub{a,1} = nameFolds;     
end

for a=1:length(pdf(:,1)) %%% Separa os arquivos
    filepath.subs{a,2} = [strcat(filepath.subs{a,1},{pdf{a,1}.name})]';
    if iscell(filepath.subs{a,2}); 
      for b=1:length(filepath.subs{a,2})
       filepath.subs{a,3}{b,1} = strcat('{"',strrep(filepath.subs{a,2}{b,1}(1:end-4),'\','/'),'"}.',formato); %% Escreve path compatível com Latex    
      end
    else
      filepath.subs{a,3} = strcat('{"',strrep(filepath.subs{a,2}{1,1}(1:end-4),'\','/'),'"}.',formato); %% Escreve path compatível com Latex
    end
end
%% Corrigi lista de sub-subs e mapeia arquivos neles contidos
for a=1:size(filepath.subs,1)
    B = filepath.subssub{a,1};
    if ~isempty(B); 
        filepath.subssub(a,1) = strcat(filepath.subs{a,1},B,'\');
        pdf{a,2} = dir(strcat(filepath.subssub{a,1},'*.',formato));
        filepath.subssub{a,2} = [strcat(filepath.subssub{a,1},{pdf{a,2}.name})]';
        if iscell(filepath.subssub{a,2}); 
          for b=1:length(filepath.subssub{a,2})
           filepath.subssub{a,3}{b,1} = strcat('{"',strrep(filepath.subssub{a,2}{b,1}(1:end-4),'\','/'),'"}.',formato); %% Escreve path compatível com Latex    
          end
        else
          filepath.subssub{a,3} = strcat('{"',strrep(filepath.subssub{a,2}{1,1}(1:end-4),'\','/'),'"}.',formato); %% Escreve path compatível com Latex
        end
    end
end; clear B;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end