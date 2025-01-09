package org.example;

import org.neo4j.graphdb.Label;
import org.neo4j.graphdb.Transaction;
import org.neo4j.procedure.Context;
import org.neo4j.procedure.Description;
import org.neo4j.procedure.Procedure;

import java.util.stream.Stream;

public class GetAirlines {
    @Context
    public Transaction txn;

    public static class JourneyResult {
        public String alias;

        public JourneyResult(String alias) {
            this.alias = alias;
        }

    }

    @Procedure(name="org.example.getAirlines")
    @Description("Returns airlines from the database")
    public Stream<JourneyResult> getAirlines() {
        return txn.findNodes(Label.label("Airline")).stream()
                .map(node -> new JourneyResult((String) node.getProperty("alias")));
    }

}
