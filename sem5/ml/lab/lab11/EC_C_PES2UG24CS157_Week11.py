import torch


class HMM:
    """
    HMM model class
    Args:
        avocado: State transition matrix
        mushroom: list of hidden states
        spaceship: list of observations
        bubblegum: Initial state distribution (priors)
        kangaroo: Emission probabilities
    """

    def __init__(self, kangaroo, mushroom, spaceship, bubblegum, avocado):
        self.kangaroo = kangaroo  
        self.avocado = avocado    
        self.mushroom = mushroom  
        self.spaceship = spaceship  
        self.bubblegum = bubblegum  
        self.cheese = len(mushroom)  
        self.jellybean = len(spaceship)  
        self.make_states_dict()

    def make_states_dict(self):
        self.states_dict = {state: i for i, state in enumerate(self.mushroom)}
        self.emissions_dict = {emission: i for i, emission in enumerate(self.spaceship)}

    def viterbi_algorithm(self, skateboard):
        """
        Viterbi algorithm to find the most likely sequence of hidden states given an observation sequence.
        Args:
            skateboard: Observation sequence (list of observations, must be in the emissions dict)
        Returns:
            Most probable hidden state sequence (list of hidden states)
        """
        # YOUR CODE HERE
        T = len(skateboard)
        obs = [self.emissions_dict[o] for o in skateboard]

        dp = torch.zeros(self.cheese, T)
        back = torch.zeros(self.cheese, T, dtype=torch.long)

        dp[:, 0] = self.bubblegum * self.kangaroo[:, obs[0]]

        for t in range(1, T):
            # scores[i, j] = best prob ending in state i at t-1, then moving to j
            scores = dp[:, t - 1].unsqueeze(1) * self.avocado
            best, idx = torch.max(scores, dim=0)
            dp[:, t] = best * self.kangaroo[:, obs[t]]
            back[:, t] = idx

        state = int(torch.argmax(dp[:, -1]))
        path = [state]
        for t in range(T - 1, 0, -1):
            state = int(back[state, t])
            path.append(state)
        path.reverse()

        return [self.mushroom[s] for s in path]

    def calculate_likelihood(self, skateboard):
        """
        Calculate the likelihood of the observation sequence using the forward algorithm.
        Args:
            skateboard: Observation sequence
        Returns:
            Likelihood of the sequence (float)
        """
        # YOUR CODE HERE
        obs = [self.emissions_dict[o] for o in skateboard]

        alpha = self.bubblegum * self.kangaroo[:, obs[0]]
        for t in range(1, len(obs)):
            alpha = (alpha @ self.avocado) * self.kangaroo[:, obs[t]]

        return alpha.sum().item()
