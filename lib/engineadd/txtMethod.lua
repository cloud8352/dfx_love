txtMethod = {}

function txtMethod:cutby(txtString,DivStr)

  local cuttxt = {} --分割出的文本table
  local j = 1 	--table组号
  local li = 0 --上次的分割点
  local ss 		--每个字符临时存放

  for i=1,string.len(txtString) do
  	--遍历字符串中所有元素
  	ss = string.sub(txtString,i,i)
  	if(ss == DivStr) then
  		--如果检测到分割符，就开始分割
  		cuttxt[j] = string.sub(txtString,li + 1,i - 1)
  		li = i
  		j = j + 1
  	end
  end

  --如果字符串最后一组，最后一位字符没有加分隔符
  if ss ~= DivStr then
  	cuttxt[j] = string.sub(txtString,li + 1,string.len(txtString))
  end
  
  return cuttxt

end


--将字符串中某个字符替换为指定字符
--txtString,输入字符串；determine,带替换掉的字符；usereplace，需要替换成的字符
--返回：替换完成后的字符串
function txtMethod:replace(txtString, determine, usereplace)
        local imgaddress = {}   --临时图片地址
        for i=1,string.len(txtString) do
            --遍历字符串中所有元素
            imgaddress[i] = string.sub(txtString,i,i)
            if imgaddress[i] == determine then
              --如果检测到determine，就替换为usereplace
              imgaddress[i] = usereplace
            end
            --将字符逐个存入第一个单元
            if i > 1 then
              imgaddress[1] = imgaddress[1]..imgaddress[i]
            end
        end
        return imgaddress[1]
end