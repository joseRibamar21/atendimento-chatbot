from rasa_sdk import Action
from rasa_sdk.events import SlotSet

class ActionCustomizada(Action):
    def name(self):
        return "action_customizada"

    def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(text="Esta é uma ação customizada!")
        return []
