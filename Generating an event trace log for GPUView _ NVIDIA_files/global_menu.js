/* TOPNAV overwrite for Geforce.com links for IE6 and IE7 */
window.setTimeout("checkLink()",1000);

function checkLink() {
	if (navigator.userAgent.indexOf('MSIE 6.0')>-1 || navigator.userAgent.indexOf('MSIE 7.0')>-1) {
		try {
			var cachedNav=document.getElementById('GfDriversLink');

			if (cachedNav.href=='http://www.geforce.co.uk/drivers') { cachedNav.href='/Download/index.aspx?lang=en-uk'; }
			else if (cachedNav.href=='http://www.geforce.com/drivers') { cachedNav.href='/Download/index.aspx?lang=en-us'; }
			else if (cachedNav.href=='http://www.geforce.cn/drivers') { cachedNav.href='/Download/index.aspx?lang=cn'; }
			else if (cachedNav.href=='http://www.geforce.com.tw/drivers') { cachedNav.href='/Download/index.aspx?lang=tw'; }

		} catch (e) {}
	}
}


function openGlobalSelector(){
	try{
		isIE6 ? window.location.href = "/content/global/unset.php" : document.getElementById("globalSelectorOpen").style.display = "block";
	}
	catch(e){window.location.href = "/content/global/unset.php"}
}
function closeGlobalSelector(){
	var selector = document.getElementById("globalSelectorOpen");
	selector.style.display = "none";
}

var cT = new Array();
var cU = new Array();

cU['ARG'] = 'arg.nvidia.com';
cU['BRA'] = 'br.nvidia.com';
cU['CHL'] = 'chl.nvidia.com';
cU['CHN'] = 'www.nvidia.cn';
cU['CLM'] = 'clm.nvidia.com';
cU['DEU'] = 'www.nvidia.de';
cU['ESP'] = 'www.nvidia.es';
cU['FRA'] = 'www.nvidia.fr';
cU['GBR'] = 'www.nvidia.co.uk';
cU['IND'] = 'www.nvidia.co.in';
cU['ITA'] = 'www.nvidia.it';
cU['JPN'] = 'www.nvidia.co.jp';
cU['KOR'] = 'www.nvidia.co.kr';
cU['MEX'] = 'www.nvidia.com.mx';

cU['POL'] = 'www.nvidia.pl';
cU['RUS'] = 'www.nvidia.ru';
cU['TWN'] = 'www.nvidia.com.tw';
cU['USA'] = 'www.nvidia.com/content/global/no_bookmark.php?lang=tempUS';
cU['VEN'] = 'ven.nvidia.com';
/*cU['THA'] = 'www.nvidia.co.th'; */
cU['TUR'] = 'www.nvidia.com.tr';
cU['AUT'] = 'www.nvidia.de';
cU['BEL'] = 'www.nvidia.fr';
cU['CHE'] = 'www.nvidia.de';
cU['CZE'] = 'www.nvidia.co.uk';
cU['DNK'] = 'www.nvidia.co.uk';
cU['FIN'] = 'www.nvidia.co.uk';
cU['LUX'] = 'www.nvidia.fr';
cU['NLD'] = 'www.nvidia.co.uk';
cU['NOR'] = 'www.nvidia.co.uk';
cU['PER'] = 'www.nvidia.com.pe';
cU['SWE'] = 'www.nvidia.co.uk';


/* Some EU specific fixes */
var host = location.hostname;
if (host.indexOf("nvidia.eu") > -1) {
	host = location.pathname;
	host = host.substr(1,2);
	if(host == "uk" || host == "in" || host == "de" || host == "es" || host == "fr" || host == "it" || host == "pl" || host == "ru"){
		host = "nvidia.eu_" + host;
	} else {
		host = "nvidia.eu";
	}
}

if(host.indexOf("nvidia.cn") > -1){host="nvidia.cn";}
if(host.indexOf("nvidia.de") > -1){host="nvidia.de";}
if(host.indexOf("nvidia.es") > -1){host="nvidia.es";}
if(host.indexOf("nvidia.fr") > -1){host="nvidia.fr";}
if(host.indexOf("nvidia.it") > -1){host="nvidia.it";}
if(host.indexOf("nvidia.pl") > -1){host="nvidia.pl";}
if(host.indexOf("nvidia.ru") > -1){host="nvidia.ru";}
if(host.indexOf("nvidia.com.tr") > -1){host="nvidia.com.tr";}
if(host.indexOf("nvidia.co.uk") > -1){host="nvidia.co.uk";}
if(host.indexOf("nvidia.com.tw") > -1){host="nvidia.com.tw";}
if(host.indexOf("nvidia.co.jp") > -1){host="nvidia.co.jp";}
if(host.indexOf("nvidia.co.kr") > -1){host="nvidia.co.kr";}
if(host.indexOf("nvidia.co.in") > -1 || host.indexOf("nvidia.in") > -1){host="nvidia.in";}


switch (host) {
	case "origin-arg.nvidia.com":
	case "arg.nvidia.com":
		var sC = 'ARG';
		var cC = 'Cambiar';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Bélgica';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Suiza';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'República Checa';
		cT['DEU'] = 'Alemania';
		cT['DNK'] = 'Dinamarca';
		cT['ESP'] = 'España';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francia';
		cT['GBR'] = 'Inglaterra';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italia';
		cT['JPN'] = 'Japón';
		cT['KOR'] = 'Corea';
		cT['LUX'] = 'Luxemburgo';
		cT['MEX'] = 'México';
		cT['NLD'] = 'Países Bajos';
		cT['NOR'] = 'Noruega';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonia';
		cT['RUS'] = 'Rusia';
		cT['SWE'] = 'Suecia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turquía';
		cT['USA'] = 'Estados Unidos';
		cT['VEN'] = 'Venezuela';
	break;

	case "br.nvidia.com":
	case "origin-br.nvidia.com":
	case "akamai-br.nvidia.com":
	case "www.nvidia.com.br":
		var sC = 'BRA';
		var cC = 'Mudar';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Áustria';
		cT['BEL'] = 'Bélgica';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Suíça';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colômbia';
		cT['CZE'] = 'República Tcheca';
		cT['DEU'] = 'Alemanha';
		cT['DNK'] = 'Dinamarca';
		cT['ESP'] = 'Espanha';
		cT['FIN'] = 'Finlândia';
		cT['FRA'] = 'França';
		cT['GBR'] = 'Reino Unido';
		cT['IND'] = 'India';
		cT['ITA'] = 'Itália';
		cT['JPN'] = 'Japão';
		cT['KOR'] = 'Coréia';
		cT['LUX'] = 'Luxemburgo';
		cT['MEX'] = 'México';
		cT['NLD'] = 'Holanda';
		cT['NOR'] = 'Noruega';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polônia';
		cT['RUS'] = 'Rússia';
		cT['SWE'] = 'Suécia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand'; */
		cT['TUR'] = 'Turquia';
		cT['USA'] = 'Estados Unidos';
		cT['VEN'] = 'Venezuela';
	break;

	case "origin-chl.nvidia.com":
	case "chl.nvidia.com":
		var sC = 'CHL';
		var cC = 'Cambiar';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Bélgica';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Suiza';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'República Checa';
		cT['DEU'] = 'Alemania';
		cT['DNK'] = 'Dinamarca';
		cT['ESP'] = 'España';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francia';
		cT['GBR'] = 'Inglaterra';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italia';
		cT['JPN'] = 'Japón';
		cT['KOR'] = 'Corea';
		cT['LUX'] = 'Luxemburgo';
		cT['MEX'] = 'México';
		cT['NLD'] = 'Países Bajos';
		cT['NOR'] = 'Noruega';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonia';
		cT['RUS'] = 'Rusia';
		cT['SWE'] = 'Suecia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turquía';
		cT['USA'] = 'Estados Unidos';
		cT['VEN'] = 'Venezuela';
	break;

	case "cn.nvidia.com":
	case "origin-cn.nvidia.com":
	case "akamai-cn.nvidia.com":
	case "www.nvidia.cn":
	case "nvidia.cn":
		var sC = 'CHN';
		var cC = '更改默认信息';
		cT['ARG'] = '阿根廷';
		cT['AUT'] = '奥地利';
		cT['BEL'] = '比利时';
		cT['BRA'] = '巴西';
		cT['CHE'] = '瑞士';
		cT['CHL'] = '智利';
		cT['CHN'] = '中国';
		cT['CLM'] = '哥伦比亚';
		cT['CZE'] = '捷克共和国';
		cT['DEU'] = '德国';
		cT['DNK'] = '丹麦';
		cT['ESP'] = '西班牙';
		cT['FIN'] = '芬兰';
		cT['FRA'] = '法国';
		cT['GBR'] = '英国';
		cT['IND'] = '印度';
		cT['ITA'] = '意大利';
		cT['JPN'] = '日本';
		cT['KOR'] = '韩国';
		cT['LUX'] = '卢森堡';
		cT['MEX'] = '墨西哥';
		cT['NLD'] = '荷兰';
		cT['NOR'] = '挪威';
		cT['PER'] = 'Peru';
		cT['POL'] = '波兰';
		cT['RUS'] = '俄罗斯';
		cT['SWE'] = '瑞典';
		cT['TWN'] = '台湾';
		/*cT['THA'] = '泰国'; */
		cT['TUR'] = '土耳其';
		cT['USA'] = '美国';
		cT['VEN'] = '委内瑞拉';
	break;

	case "origin-clm.nvidia.com":
	case "clm.nvidia.com":
		var sC = 'CLM';
		var cC = 'Cambiar';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Bélgica';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Suiza';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'República Checa';
		cT['DEU'] = 'Alemania';
		cT['DNK'] = 'Dinamarca';
		cT['ESP'] = 'España';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francia';
		cT['GBR'] = 'Inglaterra';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italia';
		cT['JPN'] = 'Japón';
		cT['KOR'] = 'Corea';
		cT['LUX'] = 'Luxemburgo';
		cT['MEX'] = 'México';
		cT['NLD'] = 'Países Bajos';
		cT['NOR'] = 'Noruega';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonia';
		cT['RUS'] = 'Rusia';
		cT['SWE'] = 'Suecia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turquía';
		cT['USA'] = 'Estados Unidos';
		cT['VEN'] = 'Venezuela';
	break;

	case "www.nvidia.fr":
	case "origin-www.nvidia.fr":
	case "akamai-www.nvidia.fr":
	case "nvidia.eu_fr":
	case "www.nvidia.be":
	case "nvidia.fr":
		var sC = 'FRA';
		var cC = 'Langue par défaut';
		cT['ARG'] = 'Argentine';
		cT['AUT'] = 'Autriche';
		cT['BEL'] = 'Belgique';
		cT['BRA'] = 'Brésil';
		cT['CHE'] = 'Suisse';
		cT['CHL'] = 'Chili';
		cT['CHN'] = 'Chine';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'République tchèque';
		cT['DEU'] = 'Allemagne';
		cT['DNK'] = 'Danemark';
		cT['ESP'] = 'Espagne';
		cT['FIN'] = 'Finlande';
		cT['FRA'] = 'France';
		cT['GBR'] = 'Royaume Uni';
		cT['IND'] = 'Inde';
		cT['ITA'] = 'Italie';
		cT['JPN'] = 'Japon';
		cT['KOR'] = 'Corée';
		cT['LUX'] = 'Luxembourg';
		cT['MEX'] = 'Mexique';
		cT['NLD'] = 'Pays-Bas';
		cT['NOR'] = 'Norvège';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Pologne';
		cT['RUS'] = 'Russie';
		cT['SWE'] = 'Suède';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thaïlande';*/
		cT['TUR'] = 'Turquie';
		cT['USA'] = 'Etats-Unis';
		cT['VEN'] = 'Venezuela';
	break;

	case "www.nvidia.de":
	case "nvidia.de":
	case "origin-www.nvidia.de":
	case "akamai-www.nvidia.de":
	case "nvidia.eu_de":
	case "www.nvidia.ch":
	case "www.nvidia.co.at":
		var sC = 'DEU';
		var cC = 'Standardseite Wechseln';
		cT['ARG'] = 'Argentinien';
		cT['AUT'] = 'Österreich';
		cT['BEL'] = 'Belgien';
		cT['BRA'] = 'Brasilien';
		cT['CHE'] = 'Schweiz';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Kolumbien';
		cT['CZE'] = 'Tschechische Republik';
		cT['DEU'] = 'Deutschland';
		cT['DNK'] = 'Dänemark';
		cT['ESP'] = 'Spanien';
		cT['FIN'] = 'Finnland';
		cT['FRA'] = 'Frankreich';
		cT['GBR'] = 'Großbritannien';
		cT['IND'] = 'Indien';
		cT['ITA'] = 'Italien';
		cT['JPN'] = 'Japan';
		cT['KOR'] = 'Korea';
		cT['LUX'] = 'Luxemburg';
		cT['MEX'] = 'Mexiko';
		cT['NLD'] = 'Niederlande';
		cT['NOR'] = 'Norwegen';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polen';
		cT['RUS'] = 'Russland';
		cT['SWE'] = 'Schweden';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Türkei';
		cT['USA'] = 'USA';
		cT['VEN'] = 'Venezuela';
	break;

	case "www.nvidia.co.in":
	case "nvidia.co.in":
	case "nvidia.in":
	case "origin-www.nvidia.co.in":
	case "nvidia.eu_in":
	case "www.nvidia.in":
		var sC = 'IND';
		var cC = 'Change default';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Belgium';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Switzerland';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'Czech Republic';
		cT['DEU'] = 'Germany';
		cT['DNK'] = 'Denmark';
		cT['ESP'] = 'Spain';
		cT['FIN'] = 'Finland';
		cT['FRA'] = 'France';
		cT['GBR'] = 'United Kingdom';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italy';
		cT['JPN'] = 'Japan';
		cT['KOR'] = 'Korea';
		cT['LUX'] = 'Luxembourg';
		cT['MEX'] = 'Mexico';
		cT['NLD'] = 'The Netherlands';
		cT['NOR'] = 'Norway';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Poland';
		cT['RUS'] = 'Russia';
		cT['SWE'] = 'Sweden';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turkey';
		cT['USA'] = 'United States';
		cT['VEN'] = 'Venezuela';
	break;

	case "www.nvidia.it":
	case "nvidia.it":
	case "origin-www.nvidia.it":
	case "origin-www-stage.nvidia.it":
	case "nvidia.eu_it":
	case "akamai-www.nvidia.it":
		var sC = 'ITA';
		var cC = 'Cambia Default';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Belgio';
		cT['BRA'] = 'Brasile';
		cT['CHE'] = 'Svizzera';
		cT['CHL'] = 'Cile';
		cT['CHN'] = 'Cina';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'Repubblica Ceca';
		cT['DEU'] = 'Germania';
		cT['DNK'] = 'Danimarca';
		cT['ESP'] = 'Spagna';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francia';
		cT['GBR'] = 'Regno Unito';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italia';
		cT['JPN'] = 'Giappone';
		cT['KOR'] = 'Corea';
		cT['LUX'] = 'Lussemburgo';
		cT['MEX'] = 'Messico';
		cT['NLD'] = 'Paesi Bassi';
		cT['NOR'] = 'Norvegia';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonia';
		cT['RUS'] = 'Russia';
		cT['SWE'] = 'Svezia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailandia';*/
		cT['TUR'] = 'Turchia';
		cT['USA'] = 'Stati Uniti d’America';
		cT['VEN'] = 'Venezuela';
	break;

	case "www.nvidia.jp":
	case "nvidia.jp":
	case "jp.nvidia.com":
	case "origin-jp.nvidia.com":
	case "akamai-jp.nvidia.com":
	case "www.nvidia.co.jp":
	case "nvidia.co.jp":
		var sC = 'JPN';
		var cC = '設定の変更';
		cT['ARG'] = 'アルゼンチン';
		cT['AUT'] = 'オーストリア';
		cT['BEL'] = 'ベルギー';
		cT['BRA'] = 'ブラジル';
		cT['CHE'] = 'スイス';
		cT['CHL'] = 'チリ';
		cT['CHN'] = '中国';
		cT['CLM'] = 'コロンビア';
		cT['CZE'] = 'チェコ共和国';
		cT['DEU'] = 'ドイツ';
		cT['DNK'] = 'デンマーク';
		cT['ESP'] = 'スペイン';
		cT['FIN'] = 'フィンランド';
		cT['FRA'] = 'フランス';
		cT['GBR'] = 'イギリス';
		cT['IND'] = 'インド';
		cT['ITA'] = 'イタリア';
		cT['JPN'] = '日本';
		cT['KOR'] = '韓国';
		cT['LUX'] = 'ルクセンブルグ';
		cT['MEX'] = 'メキシコ';
		cT['NLD'] = 'オランダ';
		cT['NOR'] = 'ノルウェー';
		cT['PER'] = 'Peru';
		cT['POL'] = 'ポーランド';
		cT['RUS'] = 'ロシア';
		cT['SWE'] = 'スウェーデン';
		cT['TWN'] = '台湾';
		/*cT['THA'] = 'タイ';*/
		cT['TUR'] = 'トルコ';
		cT['USA'] = 'アメリカ';
		cT['VEN'] = 'ベネズエラ';
	break;

	case "kr.nvidia.com":
	case "akamai-kr.nvidia.com":
	case "origin-kr.nvidia.com":
	case "www.nvidia.co.kr":
	case "nvidia.co.kr":
		var sC = 'KOR';
		var cC = '국가 변경';
		cT['ARG'] = '아르헨티나';
		cT['AUT'] = '오스트리아';
		cT['BEL'] = '벨기에';
		cT['BRA'] = '브라질';
		cT['CHE'] = '스위스';
		cT['CHL'] = '칠레';
		cT['CHN'] = '중국';
		cT['CLM'] = '컬럼비아';
		cT['CZE'] = '체코';
		cT['DEU'] = '독일</';
		cT['DNK'] = '덴마크';
		cT['ESP'] = '스페인';
		cT['FIN'] = '핀란드';
		cT['FRA'] = '프랑스';
		cT['GBR'] = '영국';
		cT['IND'] = '인도';
		cT['ITA'] = '이탈리아';
		cT['JPN'] = '일본';
		cT['KOR'] = '한국';
		cT['LUX'] = '룩셈부르크';
		cT['MEX'] = '멕시코';
		cT['NLD'] = '네덜란드';
		cT['NOR'] = '노르웨이';
		cT['PER'] = 'Peru';
		cT['POL'] = '폴란드';
		cT['RUS'] = '러시아';
		cT['SWE'] = '스웨덴';
		cT['TWN'] = '대만';
		/*cT['THA'] = '태국';*/
		cT['TUR'] = '터키';
		cT['USA'] = '미국';
		cT['VEN'] = '베네수엘라';
	break;

	case "origin-mex.nvidia.com":
	case "mex.nvidia.com":
	case "www.nvidia.com.mx":
	case "origin-www.nvidia.com.mx":
		var sC = 'MEX';
		var cC = 'Cambiar';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Bélgica';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Suiza';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'República Checa';
		cT['DEU'] = 'Alemania';
		cT['DNK'] = 'Dinamarca';
		cT['ESP'] = 'España';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francia';
		cT['GBR'] = 'Inglaterra';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italia';
		cT['JPN'] = 'Japón';
		cT['KOR'] = 'Corea';
		cT['LUX'] = 'Luxemburgo';
		cT['MEX'] = 'México';
		cT['NLD'] = 'Países Bajos';
		cT['NOR'] = 'Noruega';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonia';
		cT['RUS'] = 'Rusia';
		cT['SWE'] = 'Suecia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turquía';
		cT['USA'] = 'Estados Unidos';
		cT['VEN'] = 'Venezuela';
	break;

	case "www.nvidia.pl":
	case "nvidia.pl":
	case "origin-www.nvidia.pl":
	case "akamai-www.nvidia.pl":
	case "nvidia.eu_pl":
	case "www.nvidia.com.pl":
		var sC = 'POL';
		var cC = 'Zmień domyślny';
		cT['ARG'] = 'Argentyna';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Belgia';
		cT['BRA'] = 'Brazylia';
		cT['CHE'] = 'Szwajcaria';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'Chiny';
		cT['CLM'] = 'Kolumbia';
		cT['CZE'] = 'Czechy';
		cT['DEU'] = 'Niemcy';
		cT['DNK'] = 'Dania';
		cT['ESP'] = 'Hiszpania';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francja';
		cT['GBR'] = 'Wielka Brytania';
		cT['IND'] = 'Indie';
		cT['ITA'] = 'Włochy';
		cT['JPN'] = 'Japonia';
		cT['KOR'] = 'Korea';
		cT['LUX'] = 'Luksemburg';
		cT['MEX'] = 'Meksyk';
		cT['NLD'] = 'Holandia';
		cT['NOR'] = 'Norwegia';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polska';
		cT['RUS'] = 'Rosja';
		cT['SWE'] = 'Szwecja';
		cT['TWN'] = 'Tajwan';
		/*cT['THA'] = 'Tajlandia';*/
		cT['TUR'] = 'Turcja';
		cT['USA'] = 'Stany Zjednoczone';
		cT['VEN'] = 'Wenezuela';
	break;

	case "www.nvidia.ru":
	case "nvidia.ru":
	case "origin-www.nvidia.ru":
	case "akamai-www.nvidia.ru":
	case "origin-www-stage.nvidia.ru":
	case "nvidia.eu_ru":
	case "www.nvidia.com.ua":
		var sC = 'RUS';
		var cC = 'язык по умолчанию';
		cT['ARG'] = 'Аргентина';
		cT['AUT'] = 'Австрия';
		cT['BEL'] = 'Бельгия';
		cT['BRA'] = 'Бразилия';
		cT['CHE'] = 'Швейцария';
		cT['CHL'] = 'Чили';
		cT['CHN'] = 'Китай';
		cT['CLM'] = 'Колумбия';
		cT['CZE'] = 'Чехия';
		cT['DEU'] = 'Германия';
		cT['DNK'] = 'Дания';
		cT['ESP'] = 'Испания';
		cT['FIN'] = 'Финляндия';
		cT['FRA'] = 'Франция';
		cT['GBR'] = 'Великобритания';
		cT['IND'] = 'Индия';
		cT['ITA'] = 'Италия';
		cT['JPN'] = 'Япония';
		cT['KOR'] = 'Корея';
		cT['LUX'] = 'Люксембург';
		cT['MEX'] = 'Мексика';
		cT['NLD'] = 'Нидерланды';
		cT['NOR'] = 'Норвегия';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Польша';
		cT['RUS'] = 'Россия';
		cT['SWE'] = 'Швеция';
		cT['TWN'] = 'Тайвань';
		/*cT['THA'] = 'Таиланд';*/
		cT['TUR'] = 'Турция';
		cT['USA'] = 'США';
		cT['VEN'] = 'Венесуэла';
	break;

	case "es.nvidia.com":
	case "origin-es.nvidia.com":
	case "akamai-es.nvidia.com":
	case "www.nvidia.es":
	case "nvidia.es":
	case "nvidia.eu_es":
	case "akamai-www.nvidia.es":
		var sC = 'ESP';
		var cC = 'Cambiar';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Bélgica';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Suiza';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'República Checa';
		cT['DEU'] = 'Alemania';
		cT['DNK'] = 'Dinamarca';
		cT['ESP'] = 'España';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francia';
		cT['GBR'] = 'Reino Unido';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italia';
		cT['JPN'] = 'Japón';
		cT['KOR'] = 'Corea';
		cT['LUX'] = 'Luxemburgo';
		cT['MEX'] = 'México';
		cT['NLD'] = 'Países Bajos';
		cT['NOR'] = 'Noruega';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonia';
		cT['RUS'] = 'Rusia';
		cT['SWE'] = 'Suecia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Tailandia';*/
		cT['TUR'] = 'Turquia';
		cT['USA'] = 'Estados Unidos';
		cT['VEN'] = 'Venezuela';
	break;

	case "ch.nvidia.com":
	case "hk.nvidia.com":
	case "tw.nvidia.com":
	case "akamai-tw.nvidia.com":
	case "origin-tw.nvidia.com":
	case "akamai-tw.nvidia.com":
	case "www.nvidia.tw":
	case "nvidia.tw":
	case "www.nvidia.com.tw":
	case "nvidia.com.tw":
		var sC = 'TWN';
		var cC = '更改預設值';
		cT['ARG'] = '阿根廷';
		cT['AUT'] = '奥地利';
		cT['BEL'] = '比利时';
		cT['BRA'] = '巴西';
		cT['CHE'] = '瑞士';
		cT['CHL'] = '智利';
		cT['CHN'] = '中國';
		cT['CLM'] = '哥倫比亞';
		cT['CZE'] = '捷克共和国';
		cT['DEU'] = '德國';
		cT['DNK'] = '丹麦';
		cT['ESP'] = '西班牙';
		cT['FIN'] = '芬兰';
		cT['FRA'] = '法國';
		cT['GBR'] = '英國';
		cT['IND'] = '印度';
		cT['ITA'] = '義大利';
		cT['JPN'] = '日本';
		cT['KOR'] = '韓國';
		cT['LUX'] = '卢森堡';
		cT['MEX'] = '墨西哥';
		cT['NLD'] = '荷兰';
		cT['NOR'] = '挪威';
		cT['PER'] = 'Peru';
		cT['POL'] = '波蘭';
		cT['RUS'] = '俄羅斯';
		cT['SWE'] = '瑞典';
		cT['TWN'] = '台灣';
		/*cT['THA'] = '泰國';*/
		cT['TUR'] = '土耳其';
		cT['USA'] = '美國';
		cT['VEN'] = '委内瑞拉';
	break;

	case "www.nvidia.co.uk":
	case "nvidia.co.uk":
	case "origin-www.nvidia.co.uk":
	case "akamai-www.nvidia.co.uk":
	case "nvidia.eu_uk":
	case "www.nvidia.ro":
	case "www.nvidia.se":
		var sC = 'GBR';
		var cC = 'Change default';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Belgium';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Switzerland';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'Czech Republic';
		cT['DEU'] = 'Germany';
		cT['DNK'] = 'Denmark';
		cT['ESP'] = 'Spain';
		cT['FIN'] = 'Finland';
		cT['FRA'] = 'France';
		cT['GBR'] = 'United Kingdom';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italy';
		cT['JPN'] = 'Japan';
		cT['KOR'] = 'Korea';
		cT['LUX'] = 'Luxembourg';
		cT['MEX'] = 'Mexico';
		cT['NLD'] = 'The Netherlands';
		cT['NOR'] = 'Norway';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Poland';
		cT['RUS'] = 'Russia';
		cT['SWE'] = 'Sweden';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turkey';
		cT['USA'] = 'United States';
		cT['VEN'] = 'Venezuela';
	break;

	case "www.nvidia.com":
	case "nvidia.com":
	case "www.nvidia.ca":
	case "origin-www.nvidia.com":
	case "akamai-www.nvidia.com":
	case "www.nvidia.net":
	case "www.nvidia.org":
		var sC = 'USA';
		var cC = 'Change default';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Belgium';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Switzerland';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'Czech Republic';
		cT['DEU'] = 'Germany';
		cT['DNK'] = 'Denmark';
		cT['ESP'] = 'Spain';
		cT['FIN'] = 'Finland';
		cT['FRA'] = 'France';
		cT['GBR'] = 'United Kingdom';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italy';
		cT['JPN'] = 'Japan';
		cT['KOR'] = 'Korea';
		cT['LUX'] = 'Luxembourg';
		cT['MEX'] = 'Mexico';
		cT['NLD'] = 'The Netherlands';
		cT['NOR'] = 'Norway';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Poland';
		cT['RUS'] = 'Russia';
		cT['SWE'] = 'Sweden';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turkey';
		cT['USA'] = 'United States';
		cT['VEN'] = 'Venezuela';
	break;

	case "origin-ven.nvidia.com":
	case "ven.nvidia.com":
		var sC = 'VEN';
		var cC = 'Cambiar';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Bélgica';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Suiza';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'República Checa';
		cT['DEU'] = 'Alemania';
		cT['DNK'] = 'Dinamarca';
		cT['ESP'] = 'España';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francia';
		cT['GBR'] = 'Inglaterra';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italia';
		cT['JPN'] = 'Japón';
		cT['KOR'] = 'Corea';
		cT['LUX'] = 'Luxemburgo';
		cT['MEX'] = 'México';
		cT['NLD'] = 'Países Bajos';
		cT['NOR'] = 'Noruega';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonia';
		cT['RUS'] = 'Rusia';
		cT['SWE'] = 'Suecia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turquía';
		cT['USA'] = 'Estados Unidos';
		cT['VEN'] = 'Venezuela';
		cT['LA'] = 'América Latina';
	break;

	case "origin-la.nvidia.com":
	case "la.nvidia.com":
		var sC = 'LA';
		var cC = 'Cambiar';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Bélgica';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Suiza';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'República Checa';
		cT['DEU'] = 'Alemania';
		cT['DNK'] = 'Dinamarca';
		cT['ESP'] = 'España';
		cT['FIN'] = 'Finlandia';
		cT['FRA'] = 'Francia';
		cT['GBR'] = 'Inglaterra';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italia';
		cT['JPN'] = 'Japón';
		cT['KOR'] = 'Corea';
		cT['LUX'] = 'Luxemburgo';
		cT['MEX'] = 'México';
		cT['NLD'] = 'Países Bajos';
		cT['NOR'] = 'Noruega';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonia';
		cT['RUS'] = 'Rusia';
		cT['SWE'] = 'Suecia';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turquía';
		cT['USA'] = 'Estados Unidos';
		cT['VEN'] = 'Venezuela';
		cT['LA'] = 'América Latina';
	break;

	default:
		var sC = 'USA';
		var cC = 'Change default';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Belgium';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Switzerland';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'Czech Republic';
		cT['DEU'] = 'Germany';
		cT['DNK'] = 'Denmark';
		cT['ESP'] = 'Spain';
		cT['FIN'] = 'Finland';
		cT['FRA'] = 'France';
		cT['GBR'] = 'United Kingdom';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italy';
		cT['JPN'] = 'Japan';
		cT['KOR'] = 'Korea';
		cT['LUX'] = 'Luxembourg';
		cT['MEX'] = 'Mexico';
		cT['NLD'] = 'The Netherlands';
		cT['NOR'] = 'Norway';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Poland';
		cT['RUS'] = 'Russia';
		cT['SWE'] = 'Sweden';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turkey';
		cT['USA'] = 'United States';
		cT['VEN'] = 'Venezuela';
	break;

	case "nvidia.eu":
		var sC = 'EU';
		var cC = 'Change default';
		cT['ARG'] = 'Argentina';
		cT['AUT'] = 'Austria';
		cT['BEL'] = 'Belgium';
		cT['BRA'] = 'Brasil';
		cT['CHE'] = 'Switzerland';
		cT['CHL'] = 'Chile';
		cT['CHN'] = 'China';
		cT['CLM'] = 'Colombia';
		cT['CZE'] = 'Czech Republic';
		cT['DEU'] = 'Germany';
		cT['DNK'] = 'Denmark';
		cT['ESP'] = 'Spain';
		cT['FIN'] = 'Finland';
		cT['FRA'] = 'France';
		cT['GBR'] = 'United Kingdom';
		cT['IND'] = 'India';
		cT['ITA'] = 'Italy';
		cT['JPN'] = 'Japan';
		cT['KOR'] = 'Korea';
		cT['LUX'] = 'Luxembourg';
		cT['MEX'] = 'Mexico';
		cT['NLD'] = 'The Netherlands';
		cT['NOR'] = 'Norway';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Poland';
		cT['RUS'] = 'Russia';
		cT['SWE'] = 'Sweden';
		cT['TWN'] = 'Taiwan';
		/*cT['THA'] = 'Thailand';*/
		cT['TUR'] = 'Turkey';
		cT['USA'] = 'United States';
		cT['VEN'] = 'Venezuela';
		cT['EU'] = 'European Union';
	break;

	case "origin-www.nvidia.com.tr":
	case "www.nvidia.com.tr":
	case "nvidia.com.tr":
		var sC = 'TUR';
		var cC = 'Varsayılan değiştirmek';
		cT['ARG'] = 'Arjantin';
		cT['AUT'] = 'Avusturya';
		cT['BEL'] = 'Belçika';
		cT['BRA'] = 'Brezilya';
		cT['CHE'] = 'İsviçre';
		cT['CHL'] = 'Şili';
		cT['CHN'] = 'Çin';
		cT['CLM'] = 'Kolombiya';
		cT['CZE'] = 'Çek Cumhuriyeti';
		cT['DEU'] = 'Almanya';
		cT['DNK'] = 'Danimarka';
		cT['ESP'] = 'İspanya';
		cT['FIN'] = 'Finlandiya';
		cT['FRA'] = 'Fransa';
		cT['GBR'] = 'Büyük Britanya';
		cT['IND'] = 'Hindistan';
		cT['ITA'] = 'İtalya';
		cT['JPN'] = 'Japonya';
		cT['KOR'] = 'Kore';
		cT['LUX'] = 'Lüksemburg';
		cT['MEX'] = 'Meksika';
		cT['NLD'] = 'Hollanda';
		cT['NOR'] = 'Norveç';
		cT['PER'] = 'Peru';
		cT['POL'] = 'Polonya';
		cT['RUS'] = 'Rusya';
		cT['SWE'] = 'İsveç';
		cT['TWN'] = 'Tayvan';
		/*cT['THA'] = 'Tayland';*/
		cT['TUR'] = 'Türkiye';
		cT['USA'] = 'ABD';
		cT['VEN'] = 'Venezuela';
	break;

	case "origin-th.nvidia.com":
	case "www.nvidia.co.th":
	case "nvidia.co.th":
		var sC = 'THA';
		var cC = 'เปลี่ยนการตั้งค่าของภาษาเริ่มต้น';
		cT['ARG'] = 'อาร์เจนตินา';
		cT['BRA'] = 'บราซิล';
		cT['CHL'] = 'ชิลี';
		cT['CHN'] = 'จีน';
		cT['CLM'] = 'โคลัมเบีย';
		cT['DEU'] = 'เยอรมนี';
		cT['ESP'] = 'สเปน';
		cT['FRA'] = 'ฝรั่งเศส';
		cT['GBR'] = 'สหราชอาณาจักร';
		cT['IND'] = 'อินเดีย';
		cT['ITA'] = 'อิตาลี';
		cT['JPN'] = 'ญี่ปุ่น';
		cT['KOR'] = 'เกาหลีใต้';
		cT['MEX'] = 'เม็กซิโก';
		cT['PER'] = 'Peru';
		cT['POL'] = 'โปแลนด์';
		cT['RUS'] = 'รัสเซีย';
		cT['TWN'] = 'ไต้หวัน';
		/*cT['THA'] = 'ประเทศไทย';*/
		cT['TUR'] = 'ประเทศตุรกี';
		cT['USA'] = 'สหรัฐอเมริกา';
		cT['VEN'] = 'เวเนซุเอลา';
	break;
}


function $for(obj, callback){ // prototype to avoid... prototype stupidity with for in loops (http://webreflection.blogspot.com/2007/03/for-in-loop-prototype-safe.html)
	var proto = obj.constructor.prototype,
	h = obj.hasOwnProperty, key;
	for(key in obj) {
		if((h && h.call(obj,key)) || proto[key] !== obj[key]){
			callback(key, obj[key]);
		}
	}
};


/* New Style Global Selector */
//cI != null ? cI = '<img src="/content/includes/redesign2010/images/redesign10/flags/'+cI+'.gif" alt="" style="position:relative;float:left;top:3px;left:auto;padding:0;margin-right:3px;"/>' : cI = '';
document.write('<div id="globalSelector"><div class="currentTitle">'+sC+' - '+cT[sC]+' <img style="cursor:pointer;" src="//www.nvidia.com/content/includes/masthead/expand_arrow.jpg" alt="" onclick="javascript:openGlobalSelector();"/></div><div id="globalSelectorOpen"><div class="currentTitle">'+sC+' - '+cT[sC]+' <img style="cursor:pointer;" src="//www.nvidia.com/content/includes/masthead/close_cross.jpg" alt="" onclick="javascript:closeGlobalSelector();"/></div>');
// for(var i in cT) {
	// document.write('<p><a href="http://'+cU[i]+'">'+i+' - '+cT[i]+'</a></p>');
// }

$for(cT, function(key,value){
	if(cU[key]){
		document.write('<p><a href="http://'+cU[key]+'">'+key+' - '+cT[key]+'</a></p>');
	}
});
document.write('<div class="changeDefault"><a href="http://www.nvidia.com/content/global/unset.php">'+cC+'</a></div></div></div>');


function hide_advanced_buttons()
{
	if (document.getElementById("crm-sort-elements").style.display === '')
		{
			document.getElementById("crm-sort-elements").style.display = 'none';
		}
		else
		{
			document.getElementById("crm-sort-elements").style.display = '';
		}	
}