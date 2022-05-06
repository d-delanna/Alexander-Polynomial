class AlexanderPolynomial:
    def __init__(self, planar_diagram):
        self.pd = planar_diagram
        self.edges = []

        for idx, (_, y, _, w) in enumerate(self.pd):
            self.edges.append(sorted([y, w]))
            direction = True  # direction is positive
            if y < w:
                direction = False  # direction is negative
            self.pd[idx] = [self.pd[idx], direction]

        self.edges.sort()
        self.var_idx = 0
        self.find_identified_edges()
        self.redefine_pd()

        self.ap = self.alexander_polynom()

    def find_identified_edges(self):
        identified_edges = [self.edges[0]]
        for idx, edge in enumerate(self.edges[1:]):
            if edge[0] == self.edges[idx][1]:
            # if end of previous edge is same as beginning of next edge
                identified_edges[-1].append(edge[1])
            else:
                identified_edges.append(edge)
        self.edges = sorted(identified_edges)

    def redefine_pd(self):
        edge_names = dict()
        for idx, edge in enumerate(self.edges):
            edge_names.update(dict.fromkeys(edge, self.var_idx))
            self.var_idx += 1
            try:
                for num in range(self.edges[idx][-1]+1, self.edges[idx+1][0]):
                    edge_names[num] = self.var_idx
                    self.var_idx += 1
            except IndexError:
                pass
        for idx, direction in enumerate(self.pd):
            self.pd[idx][0] = [edge_names[num] for num in self.pd[idx][0]]

    def alexander_polynom(self):
        t = var('t')
        mat = []
        for cross, direction in self.pd[1:]:
            row = [0 for _ in range(self.var_idx)]
            row[cross[1]] += 1-t
            if direction:  # if crossing is possitive
                row[cross[0]], row[cross[2]] = -1, t
            else:  # if crossing is negative
                row[cross[0]], row[cross[2]] = t, -1
            mat += [row[1:]]
        return expand(Matrix(mat).determinant())

    def __repr__(self):
        return str(self.ap)


def main():
    planar_diagrams = {
        '3_1' : [[2,6,3,5], [4,2,5,1], [6,4,1,3]],
        '4_1' : [[4,2,5,1],[8,6,1,5],[6,3,7,4],[2,7,3,8]],
        '5_1' : [[2,8,3,7],[4,10,5,9],[6,2,7,1],[8,4,9,3],[10,6,1,5]],
        'Example Knot' : [[8,1,9,2], [4,10,5,9], [10,4,1,3], [5,3,6,2], [6,7,7,8]],
    }

    for pd in planar_diagrams:
        print(f"\nPlanar Diagram of {pd}: {planar_diagrams[pd]}")
        print("Alexander Polynomial:", AlexanderPolynomial(planar_diagrams[pd]))


if __name__ == '__main__':
    main()
