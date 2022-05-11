<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaat</title>
<style>
.oikealle{
	text-align: right;
}
</style>
</head>
<body>
	<table id="listaus">
		<thead>
			<tr>
				<th colspan="3"><input type="text" placeholder="Hakusana..." id="hakusana"></th>
				<th><input type="button" id="hae" value="Hae"></th>
				<th colspan="3" class="oikealle"><span class="oikealle" id="uusiAsiakas">Lisää uusi asiakas</span></th>
			</tr>	
			<tr>
				<th>ID</th>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sähköposti</th>
				<th colspan="2"></th>			
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
<script>
$(document).ready(function(){
	
	$("#uusiAsiakas").click(function(){
		document.location="lisaaasiakas.jsp";
	});
	$("#muutaAsiakas").click(function(){
		document.location="muutaasiakas.jsp";
	});
	
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enteriä painettu, ajetaan haku
			  haeTiedot();
		  }
	});	
	$("#hae").click(function(){	
		haeTiedot();
	});
	$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
	haeTiedot();
});

function haeTiedot(){	
	$("#listaus tbody").empty();
	$.ajax({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){
		$.each(result.asiakkaat, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr id='rivi_"+field.asiakas_id+"'>";
        	htmlStr+="<td>"+field.asiakas_id+"</td>";
        	htmlStr+="<td>"+field.etunimi+"</td>";
        	htmlStr+="<td>"+field.sukunimi+"</td>";
        	htmlStr+="<td>"+field.puhelin+"</td>";
        	htmlStr+="<td>"+field.sposti+"</td>";
        	htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+field.asiakas_id+"'>Muuta</a></td>";
        	htmlStr+="<td><span class='poista' onclick=poista("+field.asiakas_id+",'"+field.etunimi+"','"+field.sukunimi+"')>Poista</span></td>";
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);
        });
    }});	
}
function poista(asiakas_id, etunimi, sukunimi){
	if(confirm("Poista asiakas ID:llä " + asiakas_id  + " " + etunimi + " " + sukunimi + "?")){
	$.ajax({url:"asiakkaat/"+asiakas_id, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
        if(result.response==0){
        	$("#ilmo").html("Asiakkaan poisto epäonnistui.");
        } else if(result.response==1){
        	$("#rivi_"+asiakas_id).css("background-color", "red"); //Värjätään poistetun asiakkaan rivi
        	alert("Asiakkaan " + asiakas_id + ", " + etunimi + " " + sukunimi + " poisto onnistui");
			haeTiedot();        	
			}
    }});
	}
}
</script>
</body>
</html>