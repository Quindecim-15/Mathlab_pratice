% 预设变量及准备工作
slCharacterEncoding('GBK'); % 恢复字符串解码的默认配置，以可以读取中文路径
cd('D:\Work\设备管理(设备搬迁)\录入');
[file_list,path] = uigetfile(...
{'*.txt',...
    'Text Files (*.txt)'},...
    'Select a File',...
     'MultiSelect', 'on');
 if iscell(file_list) == 0
     file_list = {file_list};
 end
 
 slCharacterEncoding('UTF-8'); % 解码方式改为UTF-8,否则读取中文会乱码
 for fi = 1 : length(file_list)    
    txtff = fullfile(path,file_list{fi});
    fun = @(s)regexp(s,'\s+','split'); % 定义匿名格式筛选函数，Match regular expression函数，用于分离出被任意长度空格分割的字符char并将其返回   
    [fid,msg] = fopen(txtff,'rt'); % fopen用于获取fileID，msg用于打开不正确文件时的弹窗警告
    assert(fid>=3,msg) % 文件类型错误弹窗警告，当条件不满足时弹出
    
    % 建立元组cell并储存数据
    out = {};%#ok<NASGU> % 设立元组cell
    out = fun(fgetl(fid));
    out_rn = 2;
    while ~feof(fid)
        str = fun(fgetl(fid));
        out(out_rn,1) = str(1,1);
        out(out_rn,2) = str(1,2);
        out(out_rn,3) = str(1,3);
        out_rn = out_rn + 1; % 扩展元组cell
    end
    fclose(fid);
    
    % 修改cell，将相同类型数据合并（增加数量，删去相同数据）
    step = 1;
    m = size(out,1); %#ok<ASGLU>   
    search_count = 1;
    while search_count <= m % 确保所有行数据都历过
        m = size(out,1); %#ok<ASGLU> % 动态读取上界防止索引越界       
        if strcmp(out(search_count,1),out(step,1)) && strcmp(out(search_count,2),out(step,2)) &&  step~= search_count           
           out{search_count,3} = string(str2double(out(search_count,3)) + str2double(out(step,3)));
           out{search_count,3} = char(out{search_count,3}); % cell{}大括号对应其储存内容，()小括号对应1*1元组，char会将数字转换为ascii码对应字符
           out(step,:) = [];
           step = 1;
        else
            step = step + 1;            
        end
        if step >= m
            step = 1;
            search_count = search_count + 1;
        end
    end
    
    % 生成结果
    cd('D:\Work\设备管理(设备搬迁)\统计');
    filename = cell2mat(strcat(regexp(file_list{fi},'.*\.','match'), 'xlsx')); % 合成文件名，regexp函数返回的是1*1元组
    copyfile('实验室耗材类统计表_模板.xlsx',filename);
    m = size(out,1);
    xlrange_A = char(strcat('A2:','A',string(m)));
    xlrange_B = char(strcat('B2:','B',string(m)));
    xlrange_C = char(strcat('C2:','C',string(m)));
    xlswrite(filename,out(:,1),1,xlrange_A); % xlswrite函数的运行很慢，建议不要高频次使用
    xlswrite(filename,out(:,2),1,xlrange_B);
    xlswrite(filename,out(:,3),1,xlrange_C);
 end
 cd('D:\Work\设备管理(设备搬迁)\录入');
 disp(' reocrd_002.m finished ')
