package physical;

import java.sql.Date;

public class PhysicalInfoDTO {
    private int historyId;
    private String userId;
    private Date measuerDate;
    private double weight;
    private double musdeMass;
    private double bodyFatPct;

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Date getMeasuerDate() {
        return measuerDate;
    }

    public void setMeasuerDate(Date measuerDate) {
        this.measuerDate = measuerDate;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public double getMusdeMass() {
        return musdeMass;
    }

    public void setMusdeMass(double musdeMass) {
        this.musdeMass = musdeMass;
    }

    public double getBodyFatPct() {
        return bodyFatPct;
    }

    public void setBodyFatPct(double bodyFatPct) {
        this.bodyFatPct = bodyFatPct;
    }
}