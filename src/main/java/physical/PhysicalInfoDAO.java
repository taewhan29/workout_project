package physical;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class PhysicalInfoDAO {

    public List<PhysicalInfoDTO> getHistoryByUserId(String userId) {
        List<PhysicalInfoDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM physical_info_history WHERE user_id = ? ORDER BY measuer_date DESC, history_id DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                PhysicalInfoDTO dto = new PhysicalInfoDTO();
                dto.setHistoryId(rs.getInt("history_id"));
                dto.setUserId(rs.getString("user_id"));
                dto.setMeasuerDate(rs.getDate("measuer_date"));
                dto.setWeight(rs.getDouble("weight"));
                dto.setMusdeMass(rs.getDouble("musde_mass"));
                dto.setBodyFatPct(rs.getDouble("body_fat_pct"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return list;
    }

    public boolean insertHistory(PhysicalInfoDTO dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;

        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO physical_info_history (user_id, measuer_date, weight, musde_mass, body_fat_pct) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getUserId());
            pstmt.setDate(2, dto.getMeasuerDate());
            pstmt.setDouble(3, dto.getWeight());
            pstmt.setDouble(4, dto.getMusdeMass());
            pstmt.setDouble(5, dto.getBodyFatPct());

            int count = pstmt.executeUpdate();
            if (count > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return result;
    }
}