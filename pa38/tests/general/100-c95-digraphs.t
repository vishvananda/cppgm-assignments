%:if defined(__cplusplus) || __STDC__ != 1 || __STDC_VERSION__ != 199409L
%:error wrong C95 language mode
%:endif

%:define JOIN(a, b) a %:%: b
%:define OPEN_INDEX JOIN(<, :)

int main(void) <%
    int values<:2:> = <% 5, 8 %>;
    return values OPEN_INDEX 1:> != 8;
%>
