import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/agentesModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgentesPage extends StatelessWidget {
  const AgentesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final agenteBloc = ProviderBloc.agentes(context);
    agenteBloc.obtenerAgentes();
    return Scaffold(
      appBar: AppBar(
        title: Text("Agentes"),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
          stream: agenteBloc.agenteStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<AgenteModel>> snapshot) {
            List<AgenteModel> agente = snapshot.data;
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                    itemCount: agente.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTile(
                        //initiallyExpanded: true,
                        title: Text("Agente ${agente[index].agenteNombre}"),
                        subtitle: Text("${agente[index].agenteCodigo}"),
                        leading: Icon(FontAwesomeIcons.building),
                        childrenPadding: EdgeInsets.all(0),
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 60),
                            child: ListTile(
                              title: Text(
                                  "Dirección: ${agente[index].agenteDireccion}"),

                              //leading: Icon(Icons.format_list_bulleted_outlined),
                              // onTap: () {
                              //   Navigator.pushReplacementNamed(
                              //       context, "gridListarPrincipal");
                              // },
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                return Container(
                  width: double.infinity,
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Buscando Agentes'),
                          CircularProgressIndicator(),
                        ]),
                  ),
                );
              }
            } else {
              return Center(child: Text('No se encuentra ningún agente'));
            }
          }),
    );
  }
}
