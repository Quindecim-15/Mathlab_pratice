% Ԥ�������׼������
cd('D:\Work\�豸����(�豸��Ǩ)\¼��');
[file_list,path] = uigetfile(...
{'*.txt',...
    'Text Files (*.txt)'},...
    'Select a File',...
     'MultiSelect', 'on');
 if iscell(file_list) == 0
     file_list = {file_list};
 end
 
 slCharacterEncoding('UTF-8');%���뷽ʽ��ΪUTF-8,�����ȡ���Ļ�����
 for fi = 1 : length(file_list)
    txtff = fullfile(path,file_list{fi});
    fun = @(s)regexp(s,'\s*','split');%����������ʽɸѡ������Match regular expression���������ڷ���������ⳤ�ȿո�ָ���ַ������䷵��   
    [fid,msg] = fopen(txtff,'rt');% fopen���ڻ�ȡfileID��msg���ڴ򿪲���ȷ�ļ�ʱ�ĵ�������
    assert(fid>=3,msg)%�ļ����ʹ��󵯴�����
    
    % ����Ԫ��cell����������
    out = {};%#ok<NASGU> %����Ԫ��cell
    out = fun(fgetl(fid));
    out_rn = 2;
    while ~feof(fid)
        str = fun(fgetl(fid));
        out(out_rn,1) = str(1,1);
        out(out_rn,2) = str(1,2);
        out(out_rn,3) = str(1,3);
        out_rn = out_rn + 1;%��չԪ��cell
    end
    fclose(fid);
    
    % ���ɽ��
    cd('D:\Work\�豸����(�豸��Ǩ)\ͳ��');
    filename = cell2mat(strcat(regexp(file_list{fi},'.*\.','match'), 'xlsx'));%�ϳ��ļ�����regexp�������ص���1*1Ԫ��
    copyfile('ʵ���ҺĲ���ͳ�Ʊ�_ģ��.xlsx',filename);
    xlrowl = 1;   
    [m,n] = size(out);
    for oi = 1 : m
        xlrowl = xlrowl + 1;                                   
        xlrange_A = char(strcat('A',string(xlrowl)));
        xlrange_B = char(strcat('B',string(xlrowl)));
        xlrange_C = char(strcat('C',string(xlrowl)));
        xlswrite(filename,out(oi,1),1,xlrange_A);
        xlswrite(filename,out(oi,2),1,xlrange_B);
        xlswrite(filename,out(oi,3),1,xlrange_C);
    end                     
 end
 disp(' reocrd.m finished ')