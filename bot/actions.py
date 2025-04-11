from typing import Any, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.events import SlotSet
from datetime import datetime, timedelta

# Simulando banco de dados
consultas_marcadas = ["2025-04-10", "2025-04-11"]

def formatar_data(data_texto: str) -> str:
    try:
        data = datetime.strptime(data_texto, "%d/%m/%Y")
        return data.strftime("%Y-%m-%d")
    except:
        return data_texto  # Se já estiver no formato YYYY-MM-DD ou falhar

class ActionVerificarDisponibilidade(Action):
    def name(self) -> str:
        return "action_verificar_disponibilidade"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[str, Any]) -> List[Dict[str, Any]]:

        nome = tracker.get_slot("nome")
        data = tracker.get_slot("data")
        data_formatada = formatar_data(data)

        if data_formatada in consultas_marcadas:
            dispatcher.utter_message(response="utter_dia_ocupado")
            return [SlotSet("data", None)]
        else:
            consultas_marcadas.append(data_formatada)
            dispatcher.utter_message(text=f"Consulta marcada para {nome} no dia {data}.")
            return []

class ActionProximoDiaLivre(Action):
    def name(self) -> str:
        return "action_proximo_dia_livre"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[str, Any]) -> List[Dict[str, Any]]:

        hoje = datetime.now()
        for i in range(1, 30):
            proximo = hoje + timedelta(days=i)
            data_str = proximo.strftime("%Y-%m-%d")
            if data_str not in consultas_marcadas:
                data_formatada = proximo.strftime("%d/%m/%Y")
                dispatcher.utter_message(text=f"O próximo dia livre é {data_formatada}.")
                return []
        
        dispatcher.utter_message(text="Desculpe, não encontrei nenhum dia livre nos próximos 30 dias.")
        return []
