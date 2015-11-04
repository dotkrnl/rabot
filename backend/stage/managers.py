from stage.models import StageDao


class StageManager:

    def __init__(self):
        self.dao = StageDao()

    def clear(self):
        all_stages = self.dao.get_all_stages()
        for stage in all_stages:
            self.dao.delete_cur_stage(stage)

    def add_stage(self, sid, name, info):
        if sid < 0:
            return 'Sid invalid.'
        if sid == 0:
            all_stages = self.dao.get_all_stages()
            if len(all_stages) > 0:
                sid = all_stages[-1].sid + 1
            else:
                sid = 1

        target = self.dao.get_stage_by_sid(sid)
        if target:
            return 'Stage #' + str(sid) + 'already exists.'
        else:
            self.dao.create_stage(sid, name, info)
            return 'Succeeded, new stage\'s sid: #' + str(sid)

    def get_stage(self, sid):
        if sid <= 0:
            return None
        else:
            cur_stage = self.dao.get_stage_by_sid(sid)
            if cur_stage:
                return cur_stage
            else:
                return None

    def get_all_stages(self):
        return self.dao.get_all_stages()

    def delete_stage(self, sid):
        if sid <= 0:
            return 'Sid invalid.'
        else:
            self.dao.delete_stage(sid)
            return 'Succeeded.'

    def update_stage(self, sid, new_name, new_info):
        if sid <= 0:
            return 'Sid invalid.'

        cur_stage = self.dao.get_stage_by_sid(sid)
        if cur_stage:
            if len(new_name) > 0:
                self.dao.update_name(cur_stage, new_name)
            if len(new_info) > 0:
                self.dao.update_info(cur_stage, new_info)
            return 'Succeeded.'
        else:
            return 'Stage #' + str(sid) + 'does not exist.'
