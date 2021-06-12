
do
	if (string.NicheDevTools_CaseInsensitize == nil) then
		local tableconcat = table.concat;
		local stringsub = string.sub;
		local stringupper = string.upper;
		local stringlower = string.lower;
		
		string.NicheDevTools_CaseInsensitize = function(input)
			local stringIndex = 0;
			local newString = {};
			
			local bracketsOpen = 0;
			local ignoreNext = false;
			local char, upper, lower;
			for index = 1, #input, 1 do
				char = stringsub(input, index, index);
				if (ignoreNext == true) then
					ignoreNext = false;
				elseif (char == "%") then
					ignoreNext = true;
				elseif (char == "[") then
					bracketsOpen = (bracketsOpen + 1);
				elseif (char == "]") then
					bracketsOpen = (bracketsOpen - 1);
				elseif (bracketsOpen < 1) then
					upper, lower = stringupper(char), stringlower(char);
					if (upper ~= char or lower ~= char) then
						char = ("[" .. lower .. upper .. "]");
					end
				end
				stringIndex = (stringIndex + 1);
				newString[stringIndex] = char;
			end
			
			return tableconcat(newString);
		end
	end
end
