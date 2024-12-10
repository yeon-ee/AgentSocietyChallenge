from typing import Any, Dict, List

class RecommendationScenario:
    def __init__(self, user_id: str, candidate_category: str, 
                 candidate_list: List[str], loc: List[float]):
        """
        Recommendation Scenario for the RecommendationAgent.
        Args:
            user_id: The ID of the user requesting recommendations.
            candidate_category: The category of businesses to recommend.
            candidate_list: List of candidate business IDs.
            loc: User's location as [latitude, longitude].
        """
        self.user_id = user_id
        self.candidate_category = candidate_category
        self.candidate_list = candidate_list
        self.loc = loc

    def to_dict(self) -> Dict[str, Any]:
        """
        Convert the scenario to a dictionary.
        Returns:
            dict: The scenario in dictionary format.
        """
        return {
            "user_id": self.user_id,
            "candidate_category": self.candidate_category,
            "candidate_list": self.candidate_list,
            "loc": self.loc
        }