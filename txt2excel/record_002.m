% 预设变量及准备工作
cd('D:\Work\设备管理(设备搬迁)\录入');
[file_list,path] = uigetfile(...
{'*.txt',...
    'Text Files (*.txt)'},...
    'Select a File',...
     'MultiSelect', 'on');
 if iscell(file_list) == 0
     file_list = {file_list};
 end
 
 slCharacterEncoding('UTF-8');%解码方式改为UTF-8,否则读取中文会乱码
 for fi = 1 : length(file_list)
    txtff = fullfile(path,file_list{fi});
    fun = @(s)regexp(s,'\s*','split');%定义匿名格式筛选函数，Match regular expression函数，用于分离出被任意长度空格分割的字符并将其返回   
    [fid,msg] = fopen(txtff,'rt');% fopen用于获取fileID，msg用于打开不正确文件时的弹窗警告
    assert(fid>=3,msg)%文件类型错误弹窗警告
    
    % 建立元组cell并储存数据
    out = {};%#ok<NASGU> %设立元组cell
    out = fun(fgetl(fid));
    out_rn = 2;
    while ~feof(fid)
        str = fun(fgetl(fid));
        out(out_rn,1) = str(1,1);
        out(out_rn,2) = str(1,2);
        out(out_rn,3) = str(1,3);
        out_rn = out_rn + 1;%扩展元组cell
    end
    fclose(fid);
    
    % 生成结果
    cd('D:\Work\设备管理(设备搬迁)\统计');
    filename = cell2mat(strcat(regexp(file_list{fi},'.*\.','match'), 'xlsx'));%合成文件名，regexp函数返回的是1*1元组
    copyfile('实验室耗材类统计表_模板.xlsx',filename);
    xlrowl = 1;   
    [m,n] = size(out);
    for oi = 1 : m %直接统计不作额外筛分
        xlrowl = xlrowl + 1;                                   
        xlrange_A = char(strcat('A',string(xlrowl)));
        xlrange_B = char(strcat('B',string(xlrowl)));
        xlrange_C = char(strcat('C',string(xlrowl)));
        xlswrite(filename,out(oi,1),1,xlrange_A);
        xlswrite(filename,out(oi,2),1,xlrange_B);
        xlswrite(filename,out(oi,3),1,xlrange_C);
    end                     
 end
 disp(' reocrd_002.m finished ')
