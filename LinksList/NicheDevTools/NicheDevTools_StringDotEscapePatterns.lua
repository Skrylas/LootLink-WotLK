
do
	if (string.NicheDevTools_EscapePatterns == nil) then
		local stringgsub = string.gsub;
		
		string.NicheDevTools_EscapePatterns = function(input)
			return (stringgsub(input, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1"));
		end
	end
end
